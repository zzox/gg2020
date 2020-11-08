package;

import flixel.math.FlxPoint;
import GlobalState;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.system.scaleModes.PixelPerfectScaleMode;

class PlayState extends FlxState {
	static inline final GAME_WIDTH = 240;
	static inline final GAME_HEIGHT = 135;

	var _collisionLayer:FlxTilemap;

	var _hardExits:Array<TiledObject>;
	var _softExits:Array<TiledObject>;

	var _blueFilter:FlxSprite;

	var _player:Player;

	override public function create() {
		super.create();

		FlxG.mouse.visible = false;

		// camera.pixelPerfectRender = true;
		// remove vvv when going live
		FlxG.scaleMode = new PixelPerfectScaleMode();

		// camera.followLerp = 0.5;

		bgColor = 0xff151515;

		
		createMap();
		var start:FlxPoint = findStartingPoint();

		_player = new Player(start.x, start.y, this);

		add(_collisionLayer);
		add(_player);
		add(_blueFilter);
	}

	override public function update(elapsed:Float) {		
		super.update(elapsed);

		checkHardExits();
		// checkSoftExits();

		FlxG.collide(_collisionLayer, _player);
	}

	function createMap () {
		var yUpOffset = -4;
		var xItemsOffset = -4;
		var yItemsOffset = 4;

		var map = new TiledMap(AssetPaths.ty_room__tmx);

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
		
		if (map.getLayer('items-angled') != null) {
			var _itemsLayerAngled = new FlxTilemap();
			_itemsLayerAngled.loadMapFromArray(cast(map.getLayer('items-angled'), TiledTileLayer).tileArray, map.width, map.height, AssetPaths.tiles__png,
				map.tileWidth, map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 1)
				.setPosition(0 + xItemsOffset, 0 + yItemsOffset + yUpOffset);
			add(_itemsLayerAngled);
		}

		_collisionLayer = new FlxTilemap();
		_collisionLayer.loadMapFromArray(cast(map.getLayer('collision'), TiledTileLayer).tileArray, map.width, map.height, AssetPaths.tiles__png,
			map.tileWidth, map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 1)
			.setPosition(0, yUpOffset);
		_collisionLayer.visible = false;


		_hardExits = [];
		var s = cast(map.getLayer('hard-exits'), TiledObjectLayer).objects;
		s.map(item -> {
			item.y += yUpOffset + yItemsOffset;
			item.x += xItemsOffset;
			_hardExits.push(item);
		});

		_softExits = [];
		var s = cast(map.getLayer('soft-exits'), TiledObjectLayer).objects;
		s.map(item -> {
			item.y += yUpOffset + yItemsOffset;
			item.x += xItemsOffset;
			_softExits.push(item);
		});

		_blueFilter = new FlxSprite();
		_blueFilter.makeGraphic(GAME_WIDTH, GAME_HEIGHT, 0xff00177d);
		_blueFilter.alpha = 0.3;
		_blueFilter.scrollFactor.set(0, 0);
	}

	function checkHardExits () {
		for (point in _hardExits) {
			if (Math.abs(point.x - _player.x) < 8 && Math.abs(point.y - _player.y) < 8) {
				changeRoom(point);
			}
		}
	}
	
	function checkSoftExits () {
		for (point in _softExits) {
			if (point.name != 'start' && FlxG.keys.pressed.UP && Math.abs(point.x - _player.x) < 8 && Math.abs(point.y - _player.y) < 8) {
				changeRoom(point);
			}
		}
	}

	function changeRoom (o:TiledObject) {
		trace(o.name);
		GlobalState.instance.lastRoom = GlobalState.instance.currentRoom;
		GlobalState.instance.currentRoom = o.name;
		FlxG.switchState(new PlayState());
	}

	function findStartingPoint ():FlxPoint {
		var roomName:Null<String> = GlobalState.instance.lastRoom;

		trace(roomName);
		if (roomName == null) {
			roomName = 'start';
			trace(roomName);
		}

		for (h in _hardExits) {
			if (h.name == roomName) {
				var xDiff = 0;
				if (h.properties.get('from') == 'left') {
					xDiff = 8;
				} else if (h.properties.get('from') == 'right') {
					xDiff = -8;
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
