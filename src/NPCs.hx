typedef NPCData = {
    var graphic:String;
}

class NPCs {
    static public function getNPC (name:String):Null<NPCData> {
        switch (name) {
            case 'mom': return {
                graphic: AssetPaths.mom__png
            };
            default: return null;
        }
    }
}
