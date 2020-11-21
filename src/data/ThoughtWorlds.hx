package data;

typedef ThoughtWorld = {
    var tilemap:String;
    var backgroundColor:Int;
    var colors:Array<Int>;
    var itemGraphic:String;
}

class ThoughtWorlds {
    static public function getThoughtWorld (name:String):Null<ThoughtWorld> {
        switch (name) {
            case 'mom-thought': return {
                tilemap: AssetPaths.thought_mom__tmx,
                backgroundColor: 0xffff82ce,
                colors: [0xffffffff, 0xff024aca, 0xff151515],
                itemGraphic: AssetPaths.pink_target__png
            };
            case 'old-woman-thought': return {
                tilemap: AssetPaths.thought_old_woman__tmx,
                backgroundColor: 0xfff68f37,
                colors: [0xffffffff, 0xff20b562, 0xff231712],
                itemGraphic: AssetPaths.orange_target__png
            };
            case 'joy-thought': return {
                tilemap: AssetPaths.thought_joy__tmx,
                backgroundColor: 0xffa328b3,
                colors: [0xffffffff, 0xffcf3c31, 0xff231712],
                itemGraphic: AssetPaths.purple_target__png
            }
            default: return null;
        }
    }
}
