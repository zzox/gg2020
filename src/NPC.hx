import PlayState;
import flixel.FlxSprite;

class NPC extends FlxSprite {
    var name:String;
    var follow:Bool;
    var _scene:PlayState;

    public function new (x:Float, y:Float, scene:PlayState, name:String, graphic:String) {
        super(x, y);

        loadGraphic(graphic, true, 16, 24);
        // MD:
        offset.set(4, 7);
        setSize(11, 13);

        this.name = name;
        _scene = scene;
        // MD:
        follow = true;

        animation.add('stand', [0]);
        animation.add('breathe', [0, 0, 0, 1, 2, 2, 1], 8);

        animation.play('breathe');
    }

    override function update (elapsed:Float) {
        if (follow) {
            if (x > _scene._player.x) {
                flipX = true;
            } else {
                flipX = false;
            }
        }
    }
}
