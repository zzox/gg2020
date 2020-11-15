import PlayState;
import flixel.FlxSprite;

// new class to attach a name to the sprite
class ThoughtBubble extends FlxSprite {
    public var name:String;
    public var fromNPC:String;
    public var popped:Bool = false;
    public function new (x, y, name, fromNPC) {
        super(x, y);
        this.name = name;
        this.fromNPC = fromNPC;
    }
}

class NPC extends FlxSprite {
    public var name:String;
    var follow:Bool;
    var _scene:PlayState;

    public var _bubbles:Null<FlxSprite>;
    public var _thoughtBubble:Null<ThoughtBubble>;
    public var _thoughtBubbleBackground:Null<FlxSprite>;

    public function new (x:Float, y:Float, scene:PlayState, name:String, graphic:String, bubbles:Array<NPCs.Bubble>) {
        super(x, y);

        loadGraphic(graphic, true, 16, 24);
        // MD:
        offset.set(4, 7);
        setSize(11, 13);

        this.name = name;
        _scene = scene;

        // MD:
        follow = true;

        for (bubble in bubbles) {
            if (!GlobalState.instance.completedWorlds.contains(bubble.world)) {
                if (bubble.dir == 'right') {
                    _bubbles = new FlxSprite(x + 8, y - 12);
                    _bubbles.loadGraphic(AssetPaths.thought_bubbles__png, true, 16, 16);

                    _thoughtBubble = new ThoughtBubble(x + 24, y - 20, bubble.world, name);
                    _thoughtBubble.loadGraphic(AssetPaths.thought_cloud__png, true, 16, 16);

                    _thoughtBubbleBackground = new FlxSprite(x + 24, y - 20);
                    _thoughtBubbleBackground.loadGraphic(bubble.background, true, 16, 16);
                } else {
                    _bubbles = new FlxSprite(x + 24, y);
                    _bubbles.loadGraphic(AssetPaths.thought_bubbles__png, true, 16, 16);
                    _bubbles.flipX = true;
                }
            }
        }

        if (_bubbles != null) {
            _bubbles.animation.add('idle', [0, 1, 2, 3], 4);
            _bubbles.animation.add('pop', [4, 5, 6, 7], 4, false);
            _bubbles.animation.finishCallback = finishPopAnims;
            _bubbles.animation.play('idle');
        }

        if (_thoughtBubble != null) {
            _thoughtBubble.animation.add('idle', [0, 1, 2], 4);
            _thoughtBubble.animation.add('pop', [3, 4, 5, 6], 4);
            _thoughtBubble.animation.play('idle');
        }

        if (_thoughtBubbleBackground != null) {
            _thoughtBubbleBackground.animation.add('idle', [0, 1, 2], 4);
            _thoughtBubbleBackground.animation.add('pop', [3, 4, 5, 6], 4);
            _thoughtBubbleBackground.animation.play('idle');
        }

        animation.add('stand', [0]);
        animation.add('walk', [3, 3, 0, 4, 4, 0], 6);
        animation.add('breathe', [0, 0, 0, 1, 2, 2, 1], 8);

        animation.play('breathe');
    }

    override function update (elapsed:Float) {
        if (follow && _scene._cinematic == null) {
            if (x > _scene._player.x) {
                flipX = true;
            } else {
                flipX = false;
            }
        }
    }

    public function popBubbles () {
        _bubbles.animation.play('pop');
        _thoughtBubble.animation.play('pop');
        _thoughtBubbleBackground.animation.play('pop');
    }

    function finishPopAnims (animName:String) {
        if (animName == 'pop') {
            _bubbles.visible = false;
            _thoughtBubble.visible = false;
            _thoughtBubbleBackground.visible = false;
        }
    }
}
