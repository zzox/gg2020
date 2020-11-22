package data;

typedef Room = {
    var path:String;
    var type:String;
    var darknessLevel:Float;
    var ?universalStart:Bool;
}

class Rooms {
    static public function getRoom (name:String):Null<Room> {
        switch (name) {
            case 'ty-room':  return {
                path: AssetPaths.ty_room__tmx,
                type: 'room',
                darknessLevel: 0.3
            };
            case 'ty-living-room': return {
                path: AssetPaths.ty_living_room__tmx,
                type: 'room',
                darknessLevel: 0.3
            };
            case 'hometown': return {
                path: AssetPaths.hometown__tmx,
                type: 'outdoor',
                darknessLevel: 0.5,
                universalStart: true
            };
            default: return null;
        }
    }
}
