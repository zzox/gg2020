package data;

import haxe.Constraints.Function;

typedef NPCData = {
    var graphic:String;
    var follow:Bool;
    var flipX:Bool;
    var qualify:Function;
    var canTalk:Function;
    var bubbles:Array<Bubble>;
}

typedef Bubble = {
    var dir:String;
    var world:String;
    var background:String;
}

class NPCs {
    static public function getNPC (name:String):Null<NPCData> {
        switch (name) {
            case 'mom': return {
                graphic: AssetPaths.mom__png,
                follow: true,
                flipX: false,
                qualify: () -> !GlobalState.instance.momIsSleeping,
                canTalk: () -> false,
                bubbles: [{
                    dir: 'right',
                    world: 'mom-thought',
                    background: AssetPaths.thought_background_pink__png
                }]
            };
            case 'joy': return {
                graphic: AssetPaths.joy__png,
                flipX: false,
                follow: false,
                qualify: () -> true,
                canTalk: () -> true,
                bubbles: []
            };
            case 'chris': return {
                graphic: AssetPaths.chris__png,
                flipX: false,
                follow: true,
                qualify: () -> true,
                canTalk: () -> true,
                bubbles: []
            };
            case 'old-woman': return {
                graphic: AssetPaths.old_woman__png,
                flipX: true,
                follow: false,
                canTalk: () -> true,
                qualify: () -> true,
                bubbles: [{
                    dir: 'left',
                    world: 'old-woman-thought',
                    background: AssetPaths.thought_background_orange__png
                }]
            };
            default: return null;
        }
    }
}
