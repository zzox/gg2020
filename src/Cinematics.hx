import haxe.Constraints.Function;

typedef Cinematic = {
    var type:String;
    var ?text:String;
    var ?callback:Function;
    var ?roomName:String;
    var ?actions:Array<Action>;
    var ?time:Float;
}

typedef Action = {
    var target:String;
    var type:String;
    var ?to:OptPoint;
    var ?anim:String;
    var ?visibility:Bool;
}

typedef OptPoint = {
    var ?x:Float;
    var ?y:Float;
}

class Cinematics {
    static public function getCinematic (name:String):Null<Array<Cinematic>> {
        switch (name) {
            case 'leave-house': return [{
                type: 'callback',
                callback: () -> {
                    if (GlobalState.instance.momIsSleeping) {
                        return 4;
                    } else {
                        return 1;
                    }
                }
            }, {
                type: 'text',
                text: 'What are you doing? It\'s way too late.'
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
            case 'mom-thought-win': return [{
                type: 'text',
                text: 'I\'m going to sleep.'
            }, {
                type: 'text',
                text: 'You should really be in bed.'
            }, {
                type: 'text',
                text: '... ...'
            }, {
                type: 'text',
                text: 'I trust you.'
            }, {
                type: 'actions',
                time: 1.2,
                actions: [{
                    target: 'mom',
                    type: 'move-x',
                    to: { x: 114 }
                }, {
                    target: 'mom',
                    type: 'anim',
                    anim: 'walk'
                }]
            }, {
                type: 'actions',
                time: 0,
                actions: [{
                    target: 'mom',
                    type: 'visibility',
                    visibility: false
                }]
            }, {
                type: 'callback',
                callback: () -> {
                    GlobalState.instance.momIsSleeping = true;
                    return 0;
                }
            }];
            default: return null;
        }
    }
}
