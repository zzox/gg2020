package scenes;

import flixel.system.FlxSound;
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
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import objects.BackgroundShapes;
import objects.HitItem;

class ThoughtState extends FlxState {
	static inline final GAME_WIDTH = 240;
	static inline final GAME_HEIGHT = 135;
	static inline final GAME_HEIGHT_DIFF = 8;
	static inline final LAUNCH_VELOCITY = 400;

	var _collisionLayer:FlxTilemap;
	public var _player:Player;
	var _map:TiledMap;

	public var _cinematic:Null<Array<Cinematic>> = null;

	var _trampolines:FlxTypedGroup<FlxSprite>;
	var _hitItems:FlxTypedGroup<HitItem>;
	var _spikes:FlxTypedGroup<FlxSprite>;
	var itemsRemain:Int;

	var _filter:FlxSprite;

	var worldStatus:Null<Bool> = null;

	var sound:FlxSound;

	var _spikeSound:FlxSound;
	var _hitItemSound:FlxSound;
	var _fallSound:FlxSound;
	var _trampolineSound:FlxSound;

	override public function create() {
		super.create();

		FlxG.mouse.visible = false;

		FlxG.scaleMode = new PixelPerfectScaleMode();

		// camera.followLerp = 0.5;
		camera.pixelPerfectRender = true;

		var world:ThoughtWorld = ThoughtWorlds.getThoughtWorld(GlobalState.instance.currentWorld);

		var start:FlxPoint = createMap(world);

		bgColor = 0xffffffff;

		_player = new Player(start.x, start.y, this, true, false);
		add(_player);
		add(_filter);

		worldStatus = false;
		FlxTween.tween(_filter, { alpha: 0 }, 0.5, { onComplete: (_:FlxTween) -> {
			worldStatus = null;
		}});

		camera.setScrollBoundsRect(0, 0, _map.fullWidth, GAME_HEIGHT);
		FlxG.worldBounds.set(0, 0, _map.fullWidth, GAME_HEIGHT);
		camera.follow(_player);

		_spikeSound = FlxG.sound.load(AssetPaths.spike_die__wav);
		_hitItemSound = FlxG.sound.load(AssetPaths.hit_item__wav);
		_fallSound = FlxG.sound.load(AssetPaths.fall__wav, 0.5);
		_trampolineSound = FlxG.sound.load(AssetPaths.trampoline__wav, 0.5);

		sound = FlxG.sound.play(world.song, 0, true);
		FlxTween.tween(sound, { volume: 0.5 }, 0.5);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (_player.y > GAME_HEIGHT + GAME_HEIGHT_DIFF && worldStatus == null) {
			_fallSound.play();
			loseLevel();
		}

		FlxG.collide(_collisionLayer, _player);
		FlxG.collide(_trampolines, _player, collideTrampolines);
		FlxG.collide(_spikes, _player, collideSpikes);
		FlxG.overlap(_hitItems, _player, hitItem);
	}

	function collideTrampolines (trampoline:FlxSprite, player:Player) {
		if (player.isTouching(FlxObject.DOWN) && !player.isTouching(FlxObject.LEFT) && !player.isTouching(FlxObject.RIGHT)) {
			trampoline.animation.play('bounce');
			player.maxVelocity.y = LAUNCH_VELOCITY;
			player.velocity.y = -LAUNCH_VELOCITY;
			_trampolineSound.play();
			player.launched = true;
			FlxTween.tween(player.maxVelocity, { y: 150 }, 1.0, { ease: FlxEase.quartIn, onComplete: (_:FlxTween) -> {
				player.launched = false;
			}});
		}
	}

	function collideSpikes (spike:FlxSprite, player:Player) {
		if (player.isTouching(FlxObject.DOWN) && !player.isTouching(FlxObject.LEFT) && !player.isTouching(FlxObject.RIGHT) && !worldStatus) {
			loseLevel(true);
			_spikeSound.play();
		}
	}

	function hitItem (item:HitItem, _:Player) {
		if (!item.hit) {
			item.hitMe();
			itemsRemain -= 1;
			_hitItemSound.play();

			if (itemsRemain == 0) {
				winLevel();
			}
		}
	}

	function createMap (world:ThoughtWorld):FlxPoint {
		var yUpOffset = -4;
		var platformYOffset = 8;

		_map = new TiledMap(world.tilemap);

		var _colorFilter = new FlxSprite();
		_colorFilter.makeGraphic(GAME_WIDTH, GAME_HEIGHT, world.backgroundColor);
		_colorFilter.alpha = 0.7;
		_colorFilter.scrollFactor.set(0, 0);
		add(_colorFilter);

		add(new BackgroundShapes(world.colors));

		var _platformsLayer = new FlxTilemap();
		_platformsLayer.loadMapFromArray(cast(_map.getLayer('platforms'), TiledTileLayer).tileArray, _map.width, _map.height, AssetPaths.tiles__png,
			_map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 1)
			.setPosition(0, yUpOffset);
		_platformsLayer.useScaleHack = false;

		add(_platformsLayer);

		_collisionLayer = new FlxTilemap();
		_collisionLayer.loadMapFromArray(cast(_map.getLayer('collision'), TiledTileLayer).tileArray, _map.width, _map.height, AssetPaths.tiles__png,
			_map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 1)
			.setPosition(0, yUpOffset + platformYOffset);
		_collisionLayer.allowCollisions = FlxObject.UP;
		_collisionLayer.visible = false;
		_collisionLayer.useScaleHack = false;

		add(_collisionLayer);

		_hitItems = new FlxTypedGroup<HitItem>();
		var items = cast(_map.getLayer('hits'), TiledObjectLayer).objects;
		items.map(item -> { _hitItems.add(new HitItem(item.x, item.y, this, world.itemGraphic)); });
		add(_hitItems);

		_trampolines = new FlxTypedGroup<FlxSprite>();
		if (_map.getLayer('trampolines') != null) {
			var trampolines = cast(_map.getLayer('trampolines'), TiledObjectLayer).objects;
			trampolines.map(t -> {
				var trampoline = new FlxSprite(t.x, t.y + yUpOffset + platformYOffset);
				trampoline.loadGraphic(AssetPaths.trampoline__png, true, 24, 16);
				trampoline.setSize(16, 4);
				trampoline.offset.set(4, 6);
				trampoline.animation.add('idle', [0]);
				trampoline.animation.add('bounce', [1, 2, 3, 2, 3], 8, false);
				trampoline.animation.play('idle');
				trampoline.animation.finishCallback = (_:String) -> trampoline.animation.play('idle');
				trampoline.immovable = true;
				_trampolines.add(trampoline);
			});
		}
		add(_trampolines);

		_spikes = new FlxTypedGroup<FlxSprite>();
		if (_map.getLayer('spikes') != null) {
			var spikes = cast(_map.getLayer('spikes'), TiledObjectLayer).objects;
			spikes.map(t -> {
				var spike = new FlxSprite(t.x, t.y + yUpOffset + platformYOffset, AssetPaths.spike__png);
				spike.setSize(12, 4);
				spike.offset.set(6, 6);
				spike.immovable = true;
				_spikes.add(spike);
			});
		}
		add(_spikes);

		itemsRemain = items.length;

		var start = cast(_map.getLayer('start'), TiledObjectLayer).objects[0];

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
		FlxTween.tween(sound, { volume: 0 }, 0.65);
	}

	function loseLevel (dead:Bool = false) {
		worldStatus = true;
		if (dead) {
			_player.dead = true;
		} else {
			_player.frozen = true;
		}
		FlxTween.tween(_filter, { alpha: 1 }, 0.66, { onComplete: exitLevel });
		FlxTween.tween(sound, { volume: 0 }, 0.65);
	}

	function exitLevel (_:FlxTween) {
		GlobalState.instance.fromWorld = true;
		FlxG.switchState(new PlayState());
	}
}
