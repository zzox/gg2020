package objects;

import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import scenes.ThoughtState;

class HitItem extends FlxSprite {
    public var hit:Bool = false;
    var _scene:ThoughtState;

    public function new (x:Float, y:Float, scene:ThoughtState) {
        super(x, y);

        setSize(4, 4);
        offset.set(6, 6);
        scrollFactor.set(0, 0);

        loadGraphic(AssetPaths.pink_target__png, true, 16, 16);
        animation.add('spin', [0, 1, 2, 3, 4], 8);
        animation.add('explode', [5, 6, 7, 8], 8, false);
        animation.play('spin');

        FlxTween.tween(this, {y: y + 2}, 1, { type: FlxTweenType.PINGPONG, ease: FlxEase.sineInOut });

        _scene = scene;
    }

    public function hitMe () {
        hit = true;
        animation.play('explode');
		FlxTween.tween(this, {alpha: 0}, 0.5);
    }
}
