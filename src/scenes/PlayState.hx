package scenes;

import actors.NPC;
import actors.NPC.ThoughtBubble;
import actors.Player;
import data.Cinematics;
import data.Cinematics.Action;
import data.GlobalState;
import data.NPCs;
import data.Rooms;
import data.Rooms.Room;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.system.scaleModes.PixelPerfectScaleMode;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import objects.Dialog;
import scenes.ThoughtState;

class PlayState extends FlxState {
	static inline final GAME_WIDTH = 240;
	static inline final GAME_HEIGHT = 135;
	static inline final EXIT_DISTANCE = 4;
	static inline final FROM_EXIT_DISTANCE = 8;

	var _collisionLayer:FlxTilemap;

	var _hardExits:Array<TiledObject>;
	var _softExits:Array<TiledObject>;
	var _hardCinematics:Array<TiledObject>;
	var _xCinematics:Array<TiledObject>;

	var _blueFilter:FlxSprite;

	public var _player:Player;
	var _npcs:Array<NPC>;

	var _thoughtBubbles:FlxTypedGroup<ThoughtBubble>;

	var _filter:FlxSprite;

	var cinematicIndex:Int;
	public var _cinematic:Null<Array<Cinematic>>;

	var _dialog:Null<Dialog>;

	var worldStatus:Null<Bool> = null;
	public var justSubmitted:Bool = false;

	override public function create() {
		super.create();

		FlxG.mouse.visible = false;

		// camera.pixelPerfectRender = true;
		// remove vvv when going live
		FlxG.scaleMode = new PixelPerfectScaleMode();

		// camera.followLerp = 0.5;

		bgColor = 0xff151515;

		cinematicIndex = 0;
		_cinematic = null;

		_dialog = null;

		var room:Room = Rooms.getRoom(GlobalState.instance.currentRoom);
		createMap(room);

		// TODO: get which direction player should be facing
		var start:FlxPoint = findStartingPoint(room.universalStart);

		_player = new Player(start.x, start.y, this, false);

		add(_collisionLayer);
		add(_player);
		add(_blueFilter);
		add(_filter);

		worldStatus = false;
		FlxTween.tween(_filter, { alpha: 0 }, 0.5, { onComplete: (_:FlxTween) -> {
			worldStatus = null;
		}});

		if (room.type == 'outdoor') {
			camera.setScrollBoundsRect(16, 16, GAME_WIDTH * 2, GAME_HEIGHT);
			FlxG.worldBounds.set(16, 16, GAME_WIDTH * 2, GAME_HEIGHT);
			camera.follow(_player);
		}
	}

	override public function update(elapsed:Float) {		
		super.update(elapsed);

		if (_cinematic == null && worldStatus == null) {
			checkExits();
			FlxG.overlap(_thoughtBubbles, _player, overlapThoughtBubbles);
		}

		FlxG.collide(_collisionLayer, _player);

		if (justSubmitted) {
			justSubmitted = false;
		}
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

		if (map.getLayer('ground-middle') != null) {
			var _groundMiddleLayer = new FlxTilemap();
			_groundMiddleLayer.loadMapFromArray(cast(map.getLayer('ground-middle'), TiledTileLayer).tileArray, map.width, map.height, AssetPaths.tiles__png,
				map.tileWidth, map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 1)
				.setPosition(0, yUpOffset);
			add(_groundMiddleLayer);
		}
		
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

		var collisionOutdoorYOffset = 0;
		if (room.type == 'outdoor') {
			collisionOutdoorYOffset = 8;
		}

		_collisionLayer = new FlxTilemap();
		_collisionLayer.loadMapFromArray(cast(map.getLayer('collision'), TiledTileLayer).tileArray, map.width, map.height, AssetPaths.tiles__png,
			map.tileWidth, map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 1)
			.setPosition(0, yUpOffset + collisionOutdoorYOffset);
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

		_xCinematics = [];
		if (map.getLayer('x-cinematics') != null) {
			var s = cast(map.getLayer('x-cinematics'), TiledObjectLayer).objects;
			s.map(item -> {
				item.y += yUpOffset;
				_xCinematics.push(item);
			});
		}

		_npcs = [];
		_thoughtBubbles = new FlxTypedGroup<ThoughtBubble>();
		if (map.getLayer('npcs') != null) {
			var s = cast(map.getLayer('npcs'), TiledObjectLayer).objects;
			s.map(item -> {
				var npcData:NPCData = NPCs.getNPC(item.name);
				if (npcData.qualify()) {
					var npc = new NPC(item.x, item.y, this, item.name, npcData);
					_npcs.push(npc);
					add(npc);
					add(npc._bubbles);
					add(npc._thoughtBubbleBackground);
					_thoughtBubbles.add(npc._thoughtBubble);
				}
				return null; // needs a return statement to work??
			});
		}
		add(_thoughtBubbles);

		_blueFilter = new FlxSprite();
		_blueFilter.makeGraphic(GAME_WIDTH, GAME_HEIGHT, 0xff00177d);
		_blueFilter.alpha = 0.3;
		_blueFilter.scrollFactor.set(0, 0);

		_filter = new FlxSprite();
		_filter.makeGraphic(GAME_WIDTH, GAME_HEIGHT, 0xff151515);
		_filter.scrollFactor.set(0, 0);
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

		for (point in _xCinematics) {
			if (Math.abs(point.x - _player.x) < EXIT_DISTANCE && !GlobalState.instance.completedXCinematics.contains(point.name)) {
				launchCinematic(point.name);
				GlobalState.instance.completedXCinematics.push(point.name);
			}
		}

		// soft cinematics?
	}

	function findStartingPoint (universalStart:Bool):FlxPoint {
		if (GlobalState.instance.fromWorld) {
			var currentWorld = GlobalState.instance.currentWorld;
			var startPoint:Null<FlxPoint> = null;

			_thoughtBubbles.forEach(bubble -> {
				if (bubble.name == currentWorld) {
					if (GlobalState.instance.wonWorld) {
						popBubbles(bubble.fromNPC);
						launchCinematic('$currentWorld-win');
						bubble.popped = true;
						trace('here!');
					}

					startPoint = new FlxPoint(bubble.x, bubble.y);
				}
			});

			GlobalState.instance.currentWorld = null;
			GlobalState.instance.fromWorld = false;
			GlobalState.instance.wonWorld = false;

			return startPoint;
		}

		var roomName:Null<String> = GlobalState.instance.lastRoom;

		if (roomName == null || universalStart) {
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

	function overlapThoughtBubbles (bubble:ThoughtBubble, player:Player) {
		if (player.hasHitFloor && !bubble.popped) {
			_player.frozen = true;
			FlxTween.tween(_filter, { alpha: 1 }, 0.5, { onComplete: (_:FlxTween) -> {
				GlobalState.instance.currentWorld = bubble.name;
				FlxG.switchState(new ThoughtState());
			}});
		}
	}

	function changeRoom (name:String) {
		worldStatus = true;
		FlxTween.tween(_filter, { alpha: 1 }, 0.5, { onComplete: (_:FlxTween) -> {
			GlobalState.instance.lastRoom = GlobalState.instance.currentRoom;
			GlobalState.instance.currentRoom = name;
			FlxG.switchState(new PlayState());
		}});
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
			case 'actions':
				doActions(cin.actions, cin.time);
			default: null;
		}

		if (toIndex == -1) {
			endCinematic();
		} else if (toIndex == 0) {
			cinematicIndex++;
		} else {
			cinematicIndex = toIndex;
			doCinematic();
		}
	}

	function doActions (actions:Array<Action>, time:Float) {
		for (action in actions) {
			var target = getNPC(action.target);

			switch (action.type) {
				case 'move-x': 
					FlxTween.tween(target, { x: action.to.x }, time);
				case 'anim':
					target.animation.play(action.anim);
				case 'visibility':
					target.visible = action.visibility;
				case 'flip-x':
					target.flipX = action.flipX;
			}
		}

		var timer = new FlxTimer();
		timer.start(time, (_:FlxTimer) -> doCinematic());
	}

	function getNPC (name:String):Null<NPC> {
		for (npc in _npcs) {
			if (npc.name == name) {
				return npc;
			}
		}

		return null;
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
		// ATTN: is all this necessary?
		remove(_dialog);
		_dialog.destroy();
		_dialog = null;
		doCinematic();
		justSubmitted = true;
	}

	function popBubbles(name:String) {
		_npcs.map(npc -> {
			if (npc.name == name) {
				npc.popBubbles();
			}
			return npc;
		});
	}
}
