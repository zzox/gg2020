package scenes;

import actors.Player;
import data.Cinematics.Cinematic;
import data.ThoughtWorlds;
import data.ThoughtWorlds.ThoughtWorld;
import data.GlobalState;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.system.scaleModes.PixelPerfectScaleMode;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.tweens.FlxTween;
import objects.BackgroundShapes;
import objects.HitItem;

class ThoughtState extends FlxState {
	static inline final GAME_WIDTH = 240;
	static inline final GAME_HEIGHT = 135;
	static inline final GAME_HEIGHT_DIFF = 8;

	var _collisionLayer:FlxTilemap;
	public var _player:Player;

	public var _cinematic:Null<Array<Cinematic>> = null;

	var _hitItems:FlxTypedGroup<HitItem>;
	var itemsRemain:Int;

	var _filter:FlxSprite;

	var worldStatus:Null<Bool> = null;

	override public function create() {
		super.create();

		FlxG.mouse.visible = false;

		// remove vvv when going live
		FlxG.scaleMode = new PixelPerfectScaleMode();

		// camera.followLerp = 0.5;

		var world:ThoughtWorld = ThoughtWorlds.getThoughtWorld(GlobalState.instance.currentWorld);

		var start:FlxPoint = createMap(world);

		bgColor = 0xffffffff;

		// TODO: get which direction player should be facing
		_player = new Player(start.x, start.y, this, true);
		add(_player);
		add(_filter);

		worldStatus = false;
		FlxTween.tween(_filter, { alpha: 0 }, 0.5, { onComplete: (_:FlxTween) -> {
			worldStatus = null;
		}});
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (_player.y > GAME_HEIGHT + GAME_HEIGHT_DIFF && worldStatus == null) {
			loseLevel();
		}

		FlxG.collide(_collisionLayer, _player);
		FlxG.overlap(_hitItems, _player, hitItem);
	}

	function hitItem (item:HitItem, _:Player) {
		if (!item.hit) {
			item.hitMe();
			itemsRemain -= 1;

			if (itemsRemain == 0) {
				winLevel();
			}
		}
	}

	function createMap (world:ThoughtWorld):FlxPoint {
		var yUpOffset = -4;
		var platformYOffset = 8;

		var map = new TiledMap(world.tilemap);

		var _colorFilter = new FlxSprite();
		_colorFilter.makeGraphic(GAME_WIDTH, GAME_HEIGHT, world.backgroundColor);
		_colorFilter.alpha = 0.7;
		_colorFilter.scrollFactor.set(0, 0);
		add(_colorFilter);

		add(new BackgroundShapes(world.colors));

		var _platformsLayer = new FlxTilemap();
		_platformsLayer.loadMapFromArray(cast(map.getLayer('platforms'), TiledTileLayer).tileArray, map.width, map.height, AssetPaths.tiles__png,
			map.tileWidth, map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 1)
			.setPosition(0, yUpOffset);

		add(_platformsLayer);

		_collisionLayer = new FlxTilemap();
		_collisionLayer.loadMapFromArray(cast(map.getLayer('collision'), TiledTileLayer).tileArray, map.width, map.height, AssetPaths.tiles__png,
			map.tileWidth, map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 1)
			.setPosition(0, yUpOffset + platformYOffset);
		_collisionLayer.allowCollisions = FlxObject.UP;
		_collisionLayer.visible = false;

		add(_collisionLayer);

		_hitItems = new FlxTypedGroup<HitItem>();
		var items = cast(map.getLayer('hits'), TiledObjectLayer).objects;
		items.map(item -> { _hitItems.add(new HitItem(item.x, item.y, this)); });
		add(_hitItems);

		itemsRemain = items.length;

		var start = cast(map.getLayer('start'), TiledObjectLayer).objects[0];

		_filter = new FlxSprite(0, 0);
		_filter.makeGraphic(GAME_WIDTH, GAME_HEIGHT, 0xff151515);
		_filter.scrollFactor.set(0, 0);

		return new FlxPoint(start.x, start.y);
	}

	function winLevel () {
		GlobalState.instance.wonWorld = true;
		GlobalState.instance.completedWorlds.push(GlobalState.instance.currentWorld);
		worldStatus = true;
		_player.frozen = true;
		FlxTween.tween(_filter, { alpha: 1 }, 0.66, { onComplete: exitLevel });
	}

	function loseLevel () {
		worldStatus = true;
		_player.frozen = true;
		FlxTween.tween(_filter, { alpha: 1 }, 0.66, { onComplete: exitLevel });
	}

	function exitLevel (_:FlxTween) {
		GlobalState.instance.fromWorld = true;
		FlxG.switchState(new PlayState());
	}
}
