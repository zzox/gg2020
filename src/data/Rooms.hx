package data;

typedef Room = {
    var path:String;
    var type:String;
    var ?universalStart:Bool;
}

class Rooms {
    static public function getRoom (name:String):Null<Room> {
        switch (name) {
            case 'ty-room':  return {
                path: AssetPaths.ty_room__tmx,
                type: 'room'
            };
            case 'ty-living-room': return {
                path: AssetPaths.ty_living_room__tmx,
                type: 'room'
            };
            case 'hometown': return {
                path: AssetPaths.hometown__tmx,
                type: 'outdoor',
                universalStart: true
            };
            default: return null;
        }
    }
}
