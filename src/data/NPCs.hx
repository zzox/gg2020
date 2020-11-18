package data;

import haxe.Constraints.Function;

typedef NPCData = {
    var graphic:String;
    var bubbles:Array<Bubble>;
    var qualify:Function;
    var follow:Bool;
    var flipX:Bool;
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
                bubbles: [{
                    dir: 'right',
                    world: 'mom-thought',
                    background: AssetPaths.thought_background_pink__png
                }],
                qualify: () -> !GlobalState.instance.momIsSleeping
            };
            case 'joy': return {
                graphic: AssetPaths.joy__png,
                flipX: false,
                follow: false,
                bubbles: [],
                qualify: () -> true
            };
            case 'chris': return {
                graphic: AssetPaths.chris__png,
                flipX: false,
                follow: true,
                bubbles: [],
                qualify: () -> true
            };
            case 'old-woman': return {
                graphic: AssetPaths.old_woman__png,
                flipX: true,
                follow: false,
                bubbles: [],
                qualify: () -> true
            };
            default: return null;
        }
    }
}
