package objects;

import flixel.FlxSprite;

class Item extends FlxSprite {
    public var name:String;
    var gathered:Bool = false;
    public function new (x:Float, y:Float, name:String) {
        super(x, y);
        loadGraphic(AssetPaths.items__png, true, 16, 16);

        setSize(6, 6);
        offset.set(5, 5);

        animation.add('pills', [0]);
        animation.add('tickets', [1]);

        animation.play(name);
        this.name = name;
    }
}

