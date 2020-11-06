package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.system.scaleModes.PixelPerfectScaleMode;

class PlayState extends FlxState {
	static inline final GAME_WIDTH = 240;
	static inline final GAME_HEIGHT = 135;

	var _groundBackLayer:FlxTilemap;
	var _backgroundLayer:FlxTilemap;
	var _itemsLayer:FlxTilemap;
	var _collisionLayer:FlxTilemap;

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

		_player = new Player(100, 70, this);

		createMap();

		add(_groundBackLayer);
		add(_backgroundLayer);
		add(_itemsLayer);
		add(_collisionLayer);

		add(_player);

		add(_blueFilter);
	}

	override public function update(elapsed:Float) {		
		super.update(elapsed);

		FlxG.collide(_collisionLayer, _player);
	}

	function createMap () {
		var yUpOffset = -4;
		var xItemsOffset = -4;
		var yItemsOffset = 4;

		var map = new TiledMap(AssetPaths.ty_room__tmx);

		_groundBackLayer = new FlxTilemap();
		_groundBackLayer.loadMapFromArray(cast(map.getLayer('ground-back'), TiledTileLayer).tileArray, map.width, map.height, AssetPaths.tiles__png,
			map.tileWidth, map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 1)
			.setPosition(0, yUpOffset);

		_backgroundLayer = new FlxTilemap();
		_backgroundLayer.loadMapFromArray(cast(map.getLayer('background'), TiledTileLayer).tileArray, map.width, map.height, AssetPaths.tiles__png,
			map.tileWidth, map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 1)
			.setPosition(0, yUpOffset);

		_itemsLayer = new FlxTilemap();
		_itemsLayer.loadMapFromArray(cast(map.getLayer('items'), TiledTileLayer).tileArray, map.width, map.height, AssetPaths.tiles__png,
			map.tileWidth, map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 1)
			.setPosition(0 + xItemsOffset, 0 + yItemsOffset + yUpOffset);

		_collisionLayer = new FlxTilemap();
		_collisionLayer.loadMapFromArray(cast(map.getLayer('collision'), TiledTileLayer).tileArray, map.width, map.height, AssetPaths.tiles__png,
			map.tileWidth, map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 1)
			.setPosition(0, yUpOffset);
		_collisionLayer.visible = false;

		_blueFilter = new FlxSprite();
		_blueFilter.makeGraphic(GAME_WIDTH, GAME_HEIGHT, 0xff00177d);
		_blueFilter.alpha = 0.3;
		_blueFilter.scrollFactor.set(0, 0);
	}


}
