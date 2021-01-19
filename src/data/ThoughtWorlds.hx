package data;

typedef ThoughtWorld = {
    var tilemap:String;
    var backgroundColor:Int;
    var colors:Array<Int>;
    var itemGraphic:String;
    var song:String;
}

class ThoughtWorlds {
    static public function getThoughtWorld (name:String):Null<ThoughtWorld> {
        switch (name) {
            case 'mom-thought': return {
                tilemap: AssetPaths.thought_mom__tmx,
                backgroundColor: 0xffff82ce,
                colors: [0xffffffff, 0xff024aca, 0xff151515],
                itemGraphic: AssetPaths.pink_target__png,
                song: AssetPaths.thought1__wav
            };
            case 'old-woman-thought': return {
                tilemap: AssetPaths.thought_old_woman__tmx,
                backgroundColor: 0xfff68f37,
                colors: [0xffffffff, 0xff20b562, 0xff231712],
                itemGraphic: AssetPaths.orange_target__png,
                song: AssetPaths.thought2__wav
            };
            case 'joy-thought': return {
                tilemap: AssetPaths.thought_joy__tmx,
                backgroundColor: 0xffa328b3,
                colors: [0xffffffff, 0xff6a31ca, 0xff231712],
                itemGraphic: AssetPaths.purple_target__png,
                song: AssetPaths.thought3__wav
            };
            case 'bouncer-one-thought': return {
                tilemap: AssetPaths.thought_bouncer_one__tmx,
                backgroundColor: 0xfff68f37,
                colors: [0xffffffff, 0xff20b562, 0xff231712],
                itemGraphic: AssetPaths.orange_target__png,
                song: AssetPaths.thought2__wav
            };
            case 'busdriver-thought': return {
                tilemap: AssetPaths.thought_busdriver__tmx,
                backgroundColor: 0xffff82ce,
                colors: [0xffffffff, 0xff024aca, 0xff151515],
                itemGraphic: AssetPaths.pink_target__png,
                song: AssetPaths.thought1__wav
            };
            case 'dancing-woman-thought': return {
                tilemap: AssetPaths.thought_dancing_woman__tmx,
                backgroundColor: 0xffa328b3,
                colors: [0xffffffff, 0xff6a31ca, 0xff231712],
                itemGraphic: AssetPaths.purple_target__png,
                song: AssetPaths.thought3__wav
            };
            case 'creep-one-thought': return {
                tilemap: AssetPaths.thought_creep_one__tmx,
                backgroundColor: 0xffa328b3,
                colors: [0xffffffff, 0xff6a31ca, 0xff231712],
                itemGraphic: AssetPaths.purple_target__png,
                song: AssetPaths.thought3__wav
            };
            case 'creep-two-thought': return {
                tilemap: AssetPaths.thought_creep_two__tmx,
                backgroundColor: 0xffff82ce,
                colors: [0xffffffff, 0xff024aca, 0xff151515],
                itemGraphic: AssetPaths.pink_target__png,
                song: AssetPaths.thought1__wav
            };
            default: return null;
        }
    }
}
