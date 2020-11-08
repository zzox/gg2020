typedef Room = {
    var path:String;
    var type:String;
}

class Rooms {
    static function getRoom (name:String):Null<Room> {
        switch (name) {
            case 'ty-room': 
                return {
                    path: AssetPaths.ty_room__tmx,
                    type: 'room'
                };
            default: return null;
        }
    }
}