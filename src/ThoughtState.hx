import ThoughtWorlds.ThoughtWorld;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.system.scaleModes.PixelPerfectScaleMode;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;

class ThoughtState extends FlxState {
	static inline final GAME_WIDTH = 240;
    static inline final GAME_HEIGHT = 135;

    var _collisionLayer:FlxTilemap;
    public var _player:Player;

    var _cinematic = null;

    var itemsRemain:Int;

    override public function create() {
        super.create();
        
		FlxG.mouse.visible = false;

		// remove vvv when going live
		FlxG.scaleMode = new PixelPerfectScaleMode();
        
		// camera.followLerp = 0.5;
        
        var world:ThoughtWorlds.ThoughtWorld = ThoughtWorlds.getThoughtWorld(GlobalState.instance.currentWorld);

        var start:FlxPoint = createMap(world);

		bgColor = 0xffffffff;

		// // TODO: get which direction player should be facing
		// var start:FlxPoint = findStartingPoint();
        
        _player = new Player(start.x, start.y, this, true);
        

        add(_player);
        
		// add(_blueFilter);
    }

	override public function update(elapsed:Float) {		
		super.update(elapsed);

		FlxG.collide(_collisionLayer, _player);
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

        add(_collisionLayer);

        return new FlxPoint();
    }
}
