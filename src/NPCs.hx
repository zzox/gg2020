import haxe.Constraints.Function;

typedef NPCData = {
    var graphic:String;
    var bubbles:Array<Bubble>;
    var qualify:Function;
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
                bubbles: [{
                    dir: 'right',
                    world: 'mom-thought',
                    background: AssetPaths.thought_background_pink__png
                }],
                qualify: () -> !GlobalState.instance.momIsSleeping
            };
            default: return null;
        }
    }
}
