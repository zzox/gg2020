import flixel.tweens.FlxTween;
import haxe.Constraints.Function;

typedef Cinematic = {
    var type:String;
    var ?text:String;
    var ?callback:Function;
    var ?roomName:String;
    var ?actions:Array<Action>;
}

typedef Action = {
    var target:String;
    var type:String;
    var tween:FlxTween;
}

class Cinematics {
    static public function getCinematic (name:String):Null<Array<Cinematic>> {
        switch (name) {
            case 'leave-house': return [{
                type: 'callback',
                callback: () -> {
                    if (GlobalState.instance.momIsSleeping) {
                        return 3;
                    } else {
                        return 1;
                    }
                }
            }, {
                type: 'text',
                text: 'What are you doing?'
            }, {
                type: 'text',
                text: 'You should be in bed.'
            }, {
                type: 'room-change',
                roomName: 'ty-room'
            }, {
                type: 'room-change',
                roomName: 'hometown'
            }];
            default: return null;
        }
    }
}
