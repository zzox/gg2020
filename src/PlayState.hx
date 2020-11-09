package;

import Cinematics;
import GlobalState;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.math.FlxPoint;
import flixel.system.scaleModes.PixelPerfectScaleMode;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;

class PlayState extends FlxState {
	static inline final GAME_WIDTH = 240;
	static inline final GAME_HEIGHT = 135;
	static inline final EXIT_DISTANCE = 4;
	static inline final FROM_EXIT_DISTANCE = 8;

	var _collisionLayer:FlxTilemap;

	var _hardExits:Array<TiledObject>;
	var _softExits:Array<TiledObject>;
	var _hardCinematics:Array<TiledObject>;

	var _blueFilter:FlxSprite;

	var _player:Player;

	var cinematicIndex:Int;
	public var _cinematic:Null<Array<Cinematic>>;

	var _dialog:Null<Dialog>;

	override public function create() {
		super.create();

		FlxG.mouse.visible = false;

		// camera.pixelPerfectRender = true;
		// remove vvv when going live
		FlxG.scaleMode = new PixelPerfectScaleMode();

		// camera.followLerp = 0.5;

		bgColor = 0xff151515;

		var room:Rooms.Room = Rooms.getRoom(GlobalState.instance.currentRoom);
		createMap(room);

		// TODO: get which direction player should be facing
		var start:FlxPoint = findStartingPoint();

		_player = new Player(start.x, start.y, this);

		add(_collisionLayer);
		add(_player);
		add(_blueFilter);

		cinematicIndex = 0;
		_cinematic = null;

		_dialog = null;
	}

	override public function update(elapsed:Float) {		
		super.update(elapsed);

		if (_cinematic == null) {
			checkExits();
		}

		FlxG.collide(_collisionLayer, _player);
	}

	function createMap (room) {
		var yUpOffset = -4;
		var xItemsOffset = 4;
		var yItemsOffset = 4;

		var map = new TiledMap(room.path);

		var _groundBackLayer = new FlxTilemap();
		_groundBackLayer.loadMapFromArray(cast(map.getLayer('ground-back'), TiledTileLayer).tileArray, map.width, map.height, AssetPaths.tiles__png,
			map.tileWidth, map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 1)
			.setPosition(0, yUpOffset);
		add(_groundBackLayer);
		
		var _backgroundLayer = new FlxTilemap();
		_backgroundLayer.loadMapFromArray(cast(map.getLayer('background'), TiledTileLayer).tileArray, map.width, map.height, AssetPaths.tiles__png,
			map.tileWidth, map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 1)
			.setPosition(0, yUpOffset);
		add(_backgroundLayer);

		if (map.getLayer('items') != null) {
			var _itemsLayer = new FlxTilemap();
			_itemsLayer.loadMapFromArray(cast(map.getLayer('items'), TiledTileLayer).tileArray, map.width, map.height, AssetPaths.tiles__png,
			map.tileWidth, map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 1)
			.setPosition(0, yUpOffset);
			
			add(_itemsLayer);
		}
		
		if (map.getLayer('items-angled-left') != null) {
			var _itemsLayerAngledLeft = new FlxTilemap();
			_itemsLayerAngledLeft.loadMapFromArray(cast(map.getLayer('items-angled-left'), TiledTileLayer).tileArray, map.width, map.height, AssetPaths.tiles__png,
				map.tileWidth, map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 1)
				.setPosition(0 + -xItemsOffset, 0 + yItemsOffset + yUpOffset);
			add(_itemsLayerAngledLeft);
		}

		if (map.getLayer('items-angled-right') != null) {
			var _itemsLayerAngledRight = new FlxTilemap();
			_itemsLayerAngledRight.loadMapFromArray(cast(map.getLayer('items-angled-right'), TiledTileLayer).tileArray, map.width, map.height, AssetPaths.tiles__png,
				map.tileWidth, map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 1)
				.setPosition(0 + xItemsOffset + 1, 0 + yItemsOffset + yUpOffset);
			add(_itemsLayerAngledRight);
		}

		_collisionLayer = new FlxTilemap();
		_collisionLayer.loadMapFromArray(cast(map.getLayer('collision'), TiledTileLayer).tileArray, map.width, map.height, AssetPaths.tiles__png,
			map.tileWidth, map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 1)
			.setPosition(0, yUpOffset);
		_collisionLayer.visible = false;


		_hardExits = [];
		if (map.getLayer('hard-exits') != null) {
			var s = cast(map.getLayer('hard-exits'), TiledObjectLayer).objects;
			s.map(item -> {
				item.y += yUpOffset;
				_hardExits.push(item);
			});
		}

		_softExits = [];
		if (map.getLayer('soft-exits') != null) {
			var s = cast(map.getLayer('soft-exits'), TiledObjectLayer).objects;
			s.map(item -> {
				item.y += yUpOffset;
				_softExits.push(item);
			});
		}

		_hardCinematics = [];
		if (map.getLayer('hard-cinematics') != null) {
			var s = cast(map.getLayer('hard-cinematics'), TiledObjectLayer).objects;
			s.map(item -> {
				item.y += yUpOffset;
				_hardCinematics.push(item);
			});
		}

		_blueFilter = new FlxSprite();
		_blueFilter.makeGraphic(GAME_WIDTH, GAME_HEIGHT, 0xff00177d);
		_blueFilter.alpha = 0.3;
		_blueFilter.scrollFactor.set(0, 0);
	}

	function checkExits () {
		for (point in _hardExits) {
			if (Math.abs(point.x - _player.x) < EXIT_DISTANCE && Math.abs(point.y - _player.y) < EXIT_DISTANCE) {
				changeRoom(point.name);
			}
		}

		for (point in _softExits) {
			if (point.name != 'start' && FlxG.keys.justPressed.UP && Math.abs(point.x - _player.x) < EXIT_DISTANCE && Math.abs(point.y - _player.y) < EXIT_DISTANCE) {
				changeRoom(point.name);
			}
		}

		for (point in _hardCinematics) {
			if (Math.abs(point.x - _player.x) < EXIT_DISTANCE && Math.abs(point.y - _player.y) < EXIT_DISTANCE) {
				launchCinematic(point.name);
			}
		}

		// soft cinematics
	}

	function changeRoom (name:String) {
		GlobalState.instance.lastRoom = GlobalState.instance.currentRoom;
		GlobalState.instance.currentRoom = name;
		FlxG.switchState(new PlayState());
	}

	function launchCinematic (name:String) {
		_cinematic = Cinematics.getCinematic(name);
		doCinematic();
	}

	function doCinematic () {
		var toIndex = 0;
		if (cinematicIndex == _cinematic.length) {
			endCinematic();
			return;
		}

		var cin = _cinematic[cinematicIndex];

		switch (cin.type) {
			case 'callback':
				toIndex = cin.callback();
			case 'text':
				openDialog(cin.text);
			case 'room-change':
				changeRoom(cin.roomName);
				return;
			default: null;
		}

		trace(toIndex);

		if (toIndex == 0) {
			cinematicIndex++;
		} else {
			cinematicIndex = toIndex;
			doCinematic();
		}
	}

	function endCinematic () {
		cinematicIndex = 0;
		_cinematic = null;
	}

	function openDialog (text:String) {
		_dialog = new Dialog(onCompleteDialog, text);
		add(_dialog);
	}

	function onCompleteDialog () {
		// ATTN: is this necessary?
		remove(_dialog);
		_dialog.destroy();
		_dialog = null;
		doCinematic();
	}

	function findStartingPoint ():FlxPoint {
		var roomName:Null<String> = GlobalState.instance.lastRoom;

		if (roomName == null) {
			roomName = 'start';
		}

		for (h in _hardExits) {
			if (h.name == roomName) {
				var xDiff = 0;
				if (h.properties.get('from') == 'left') {
					xDiff = FROM_EXIT_DISTANCE;
				} else if (h.properties.get('from') == 'right') {
					xDiff = -FROM_EXIT_DISTANCE;
				}

				return new FlxPoint(h.x + xDiff, h.y);
			}
		}

		for (s in _softExits) {
			if (s.name == roomName) {
				return new FlxPoint(s.x, s.y);
			}
		}

		return new FlxPoint(0, 0);
	}
}
