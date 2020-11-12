typedef ThoughtWorld = {
    var tilemap:String;
    var backgroundColor:Int;
    var colors:Array<Int>;
}

class ThoughtWorlds {
    static public function getThoughtWorld (name:String):Null<ThoughtWorld> {
        switch (name) {
            case 'mom-thought': return {
                tilemap: AssetPaths.thought_mom__tmx,
                backgroundColor: 0xffff82ce,
                colors: [0xffffffff, 0xff024aca, 0xff151515]
            };
            default: return null;
        }
    }
}
