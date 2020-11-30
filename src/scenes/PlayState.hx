package scenes;

import objects.Item;
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
import flixel.tweens.FlxEase;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.system.scaleModes.PixelPerfectScaleMode;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import objects.Dialog;
import scenes.ThoughtState;

typedef SoftExit = {
	var tiledObj:TiledObject;
	var spr:FlxSprite;
}

typedef ExitPoint = {
	var point:FlxPoint;
	var ?from:String;
}

class PlayState extends FlxState {
	static inline final GAME_WIDTH = 240;
	static inline final GAME_HEIGHT = 135;
	static inline final EXIT_DISTANCE = 4;
	static inline final SOFT_EXIT_DISTANCE = 12;
	static inline final FROM_EXIT_DISTANCE = 8;
	static inline final LEAVE_TIME = 0.5;

	var _map:TiledMap;
	var _collisionLayer:FlxTilemap;

	var _hardExits:Array<TiledObject>;
	var _softExits:Array<SoftExit>;
	var _hardCinematics:Array<TiledObject>;
	var _xCinematics:Array<TiledObject>;

	var _blueFilter:FlxSprite;

	public var _player:Player;
	var _npcs:Array<NPC>;

	var _thoughtBubbles:FlxTypedGroup<ThoughtBubble>;

	var _items:FlxTypedGroup<Item>;

	var _filter:FlxSprite;

	var cinematicIndex:Int;
	public var _cinematic:Null<Array<Cinematic>>;

	var _dialog:Null<Dialog>;

	var worldStatus:Null<Bool> = null;
	public var justSubmitted:Bool = false;

	var _bgSound:FlxSound;

	override public function create() {
		super.create();

		FlxG.mouse.visible = false;

		// camera.pixelPerfectRender = true;
		FlxG.scaleMode = new PixelPerfectScaleMode();

		// camera.followLerp = 0.5;

		bgColor = 0xff151515;

		cinematicIndex = 0;
		_cinematic = null;

		_dialog = null;

		var room:Room = Rooms.getRoom(GlobalState.instance.currentRoom);
		createMap(room);

		var start:ExitPoint = findStartingPoint(room.universalStart);

		_player = new Player(start.point.x, start.point.y, this, false, start.from == 'right');

		add(_collisionLayer);
		add(_player);
		add(_blueFilter);
		add(_filter);

		if (room.type == 'outdoor') {
			camera.setScrollBoundsRect(16, 16, _map.fullWidth - 32, GAME_HEIGHT);
			FlxG.worldBounds.set(16, 16, _map.fullWidth - 32, GAME_HEIGHT);
			camera.follow(_player);
		}

		worldStatus = false;
		FlxTween.tween(_filter, { alpha: 0 }, 0.5, { onComplete: (_:FlxTween) -> {
			worldStatus = null;
		}});

		if (FlxG.sound.defaultMusicGroup.sounds.length == 0) {
			FlxG.sound.play(AssetPaths.crickets__mp3, 0, true, FlxG.sound.defaultMusicGroup, false);
			FlxG.sound.play(AssetPaths.theme1__mp3, 0, true, FlxG.sound.defaultMusicGroup, false);
		}

		// need to use integers for now, since I don't know how to
		// properly name the sounds, I'm looking for a path variable or something
		for (i in 0...FlxG.sound.defaultMusicGroup.sounds.length) {
			var sound = FlxG.sound.defaultMusicGroup.sounds[i];
			sound.persist = true;

			var vol:Float = 0.0;
			if (room.sounds.contains(i)) {
				vol = 1.0;
			}

			FlxTween.tween(sound, { volume: vol }, 1.5);
		}
	}

	override public function update(elapsed:Float) {		
		super.update(elapsed);

		if (_cinematic == null && worldStatus == null) {
			checkExits();
			FlxG.overlap(_thoughtBubbles, _player, overlapThoughtBubbles);
			FlxG.overlap(_items, _player, overlapItem);
		}

		FlxG.collide(_collisionLayer, _player);

		if (justSubmitted) {
			justSubmitted = false;
		}
	}

	function createMap (room) {
		var yUpOffset = 4;
		var xItemsOffset = 4;
		var yItemsOffset = 4;

		_map = new TiledMap(room.path);

		var _groundBackLayer = new FlxTilemap();
		_groundBackLayer.loadMapFromArray(cast(_map.getLayer('ground-back'), TiledTileLayer).tileArray, _map.width, _map.height, AssetPaths.tiles__png,
			_map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 1)
			.setPosition(0, -yUpOffset);
		add(_groundBackLayer);

		if (_map.getLayer('ground-middle') != null) {
			var _groundMiddleLayer = new FlxTilemap();
			_groundMiddleLayer.loadMapFromArray(cast(_map.getLayer('ground-middle'), TiledTileLayer).tileArray, _map.width, _map.height, AssetPaths.tiles__png,
				_map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 1)
				.setPosition(0, -yUpOffset);
			add(_groundMiddleLayer);
		}
		
		var _backgroundLayer = new FlxTilemap();
		_backgroundLayer.loadMapFromArray(cast(_map.getLayer('background'), TiledTileLayer).tileArray, _map.width, _map.height, AssetPaths.tiles__png,
			_map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 1)
			.setPosition(0, -yUpOffset);
		add(_backgroundLayer);

		if (_map.getLayer('items') != null) {
			var _itemsLayer = new FlxTilemap();
			_itemsLayer.loadMapFromArray(cast(_map.getLayer('items'), TiledTileLayer).tileArray, _map.width, _map.height, AssetPaths.tiles__png,
			_map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 1)
			.setPosition(0, -yUpOffset);
			
			add(_itemsLayer);
		}
		
		if (_map.getLayer('items-angled-left') != null) {
			var _itemsLayerAngledLeft = new FlxTilemap();
			_itemsLayerAngledLeft.loadMapFromArray(cast(_map.getLayer('items-angled-left'), TiledTileLayer).tileArray, _map.width, _map.height, AssetPaths.tiles__png,
				_map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 1)
				.setPosition(0 + -xItemsOffset, 0 + yItemsOffset - yUpOffset);
			add(_itemsLayerAngledLeft);
		}

		if (_map.getLayer('items-angled-right') != null) {
			var _itemsLayerAngledRight = new FlxTilemap();
			_itemsLayerAngledRight.loadMapFromArray(cast(_map.getLayer('items-angled-right'), TiledTileLayer).tileArray, _map.width, _map.height, AssetPaths.tiles__png,
				_map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 1)
				.setPosition(0 + xItemsOffset + 1, 0 + yItemsOffset - yUpOffset);
			add(_itemsLayerAngledRight);
		}

		var collisionOutdoorYOffset = 0;
		if (room.type == 'outdoor') {
			collisionOutdoorYOffset = 8;
		}

		_collisionLayer = new FlxTilemap();
		_collisionLayer.loadMapFromArray(cast(_map.getLayer('collision'), TiledTileLayer).tileArray, _map.width, _map.height, AssetPaths.tiles__png,
			_map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 1)
			.setPosition(0, collisionOutdoorYOffset - yUpOffset);
		_collisionLayer.visible = false;


		_hardExits = [];
		if (_map.getLayer('hard-exits') != null) {
			var s = cast(_map.getLayer('hard-exits'), TiledObjectLayer).objects;
			s.map(item -> {
				item.y -= yUpOffset;
				_hardExits.push(item);
			});
		}

		_softExits = [];
		if (_map.getLayer('soft-exits') != null) {
			var s = cast(_map.getLayer('soft-exits'), TiledObjectLayer).objects;
			s.map(item -> {
				item.y -= yUpOffset;

				var upArrow = new FlxSprite(item.x, item.y - 32, AssetPaths.up_arrow__png);
				upArrow.visible = false;
				FlxTween.tween(upArrow, { y: upArrow.y + 2 }, 1, { type: FlxTweenType.PINGPONG, ease: FlxEase.sineInOut });
				add(upArrow);

				_softExits.push({
					spr: upArrow,
					tiledObj: item
				});
			});
		}

		_hardCinematics = [];
		if (_map.getLayer('hard-cinematics') != null) {
			var s = cast(_map.getLayer('hard-cinematics'), TiledObjectLayer).objects;
			s.map(item -> {
				item.y -= yUpOffset;
				_hardCinematics.push(item);
			});
		}

		_xCinematics = [];
		if (_map.getLayer('x-cinematics') != null) {
			var s = cast(_map.getLayer('x-cinematics'), TiledObjectLayer).objects;
			s.map(item -> {
				item.y -= yUpOffset;
				_xCinematics.push(item);
			});
		}

		_items = new FlxTypedGroup<Item>();
		if (_map.getLayer('item-objects') != null) {
			var s = cast(_map.getLayer('item-objects'), TiledObjectLayer).objects;
			s.map(item -> {
				if (!GlobalState.instance.items.contains(item.name)) {
					var _item = new Item(item.x, item.y, item.name);
					_items.add(_item);
				}
				return null;
			});
		}
		add (_items);

		_npcs = [];
		_thoughtBubbles = new FlxTypedGroup<ThoughtBubble>();
		if (_map.getLayer('npcs') != null) {
			var s = cast(_map.getLayer('npcs'), TiledObjectLayer).objects;
			s.map(item -> {
				var npcData:NPCData = NPCs.getNPC(item.name);
				if (npcData.qualify()) {
					var npc = new NPC(item.x, item.y, this, item.name, npcData);
					_npcs.push(npc);
					add(npc);
					add(npc._bubbles);
					add(npc._thoughtBubbleBackground);
					add(npc._upArrow);
					_thoughtBubbles.add(npc._thoughtBubble);
				}
				return null; // needs a return statement to work??
			});
		}
		add(_thoughtBubbles);

		_blueFilter = new FlxSprite();
		_blueFilter.makeGraphic(GAME_WIDTH, GAME_HEIGHT, 0xff00177d);
		_blueFilter.alpha = room.darknessLevel;
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

		for (softExit in _softExits) {
			if (softExit.tiledObj.name != 'start' &&
				Math.abs(softExit.tiledObj.x - _player.x) < SOFT_EXIT_DISTANCE && Math.abs(softExit.tiledObj.y - _player.y) < SOFT_EXIT_DISTANCE) {
				softExit.spr.visible = true;

				if (FlxG.keys.justPressed.UP) {
					changeRoom(softExit.tiledObj.name);
				}
			} else {
				softExit.spr.visible = false;
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
	}

	function findStartingPoint (universalStart:Bool):ExitPoint {
		if (GlobalState.instance.fromWorld) {
			var currentWorld = GlobalState.instance.currentWorld;
			var startPoint:Null<FlxPoint> = null;

			_thoughtBubbles.forEach(bubble -> {
				if (bubble.name == currentWorld) {
					if (GlobalState.instance.wonWorld) {
						popBubbles(bubble.fromNPC);
						launchCinematic('$currentWorld-win');
						bubble.popped = true;
					}

					startPoint = new FlxPoint(bubble.x, bubble.y);
				}
			});

			GlobalState.instance.currentWorld = null;
			GlobalState.instance.fromWorld = false;
			GlobalState.instance.wonWorld = false;

			return { point: startPoint };
		}

		var roomName:Null<String> = GlobalState.instance.lastRoom;

		for (h in _hardExits) {
			if (h.name == roomName) {
				var xDiff = 0;

				var from = h.properties.get('from');
				if (from == 'left') {
					xDiff = FROM_EXIT_DISTANCE;
				} else if (from == 'right') {
					xDiff = -FROM_EXIT_DISTANCE;
				}

				return { point: new FlxPoint(h.x + xDiff, h.y), from: from };
			}
		}

		// TODO: move duplicate loops to a different function
		for (s in _softExits) {
			if (s.tiledObj.name == roomName) {
				var from = s.tiledObj.properties.get('from');
				return { point: new FlxPoint(s.tiledObj.x, s.tiledObj.y), from: from };
			}
		}

		if (roomName == null || universalStart) {
			roomName = 'start';
		}

		for (s in _softExits) {
			if (s.tiledObj.name == roomName) {
				var from = s.tiledObj.properties.get('from');
				return { point: new FlxPoint(s.tiledObj.x, s.tiledObj.y), from: from };
			}
		}

		return { point: new FlxPoint(0, 0) };
	}

	function overlapThoughtBubbles (bubble:ThoughtBubble, player:Player) {
		if (player.hasHitFloor && !bubble.popped) {
			trace(bubble.name);
			_player.frozen = true;
			FlxTween.tween(_filter, { alpha: 1 }, 0.5, { onComplete: (_:FlxTween) -> {
				GlobalState.instance.currentWorld = bubble.name;
				FlxG.switchState(new ThoughtState());
			}});

			for (i in 0...FlxG.sound.defaultMusicGroup.sounds.length) {
				var sound = FlxG.sound.defaultMusicGroup.sounds[i];
				FlxTween.tween(sound, { volume: 0 }, LEAVE_TIME, { onComplete: (_:FlxTween) -> {
					FlxG.sound.defaultMusicGroup.remove(sound);
					sound.destroy();
				}});
			}
		}
	}

	function overlapItem (item:Item, player:Player) {
		getItem(item.name, player);
		item.destroy();
	}

	function getItem (name:String, player:Player) {
		var description = Item.getDescription(name);
		GlobalState.instance.items.push(name);
		worldStatus = true;
		player.presenting = true;

		var _displayItem = new Item(player.x + 2, player.y - 12, name);
		add(_displayItem);
		_cinematic = [{
			type: 'text',
			text: 'You picked up "$name"! $description'
		}, {
			type: 'callback',
			callback: () -> {
				worldStatus = null;
				player.presenting = false;
				_displayItem.destroy();
				return -1;
			}
		}];
		doCinematic();
	}

	function changeRoom (name:String) {
		worldStatus = true;
		FlxTween.tween(_filter, { alpha: 1 }, LEAVE_TIME, { onComplete: (_:FlxTween) -> {
			GlobalState.instance.lastRoom = GlobalState.instance.currentRoom;
			GlobalState.instance.currentRoom = name;
			FlxG.switchState(new PlayState());
		}});
	}

	public function launchCinematic (name:String) {
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
			case 'item':
				endCinematic();
				getItem(cin.item, _player);
				return;
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
