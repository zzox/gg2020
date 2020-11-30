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
        animation.add('a beer', [2]);
        animation.add('ten bucks', [3]);

        animation.play(name);
        this.name = name;
    }

    static public function getDescription (name:String) {
        switch (name) {
            case 'pills': return 'You use these for studying.';
            case 'tickets': return 'Finally!';
            case 'a beer': return 'But you don\'t drink...';
            case 'ten bucks': return 'Enough for two tickets!';
            default: return '';
        }
    }
}

