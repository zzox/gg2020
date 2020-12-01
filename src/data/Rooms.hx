package data;

typedef Room = {
    var path:String;
    var type:String;
    var darknessLevel:Float;
    var sounds:Array<Int>;
    var ?universalStart:Bool;
}

class Rooms {
    static public function getRoom (name:String):Null<Room> {
        switch (name) {
            case 'ty-room':  return {
                path: AssetPaths.ty_room__tmx,
                type: 'room',
                sounds: [0],
                darknessLevel: 0.3
            };
            case 'ty-living-room': return {
                path: AssetPaths.ty_living_room__tmx,
                type: 'room',
                sounds: [0],
                darknessLevel: 0.3
            };
            case 'hometown': return {
                path: AssetPaths.hometown__tmx,
                type: 'outdoor',
                sounds: [0, 3],
                darknessLevel: 0.5,
                universalStart: true
            };
            case 'bus': return {
                path: AssetPaths.bus__tmx,
                type: 'room',
                sounds: [1, 3, 5],
                darknessLevel: 0.2,
                universalStart: true
            };
            case 'downtown': return {
                path: AssetPaths.downtown__tmx,
                type: 'outdoor',
                sounds: [3, 4],
                darknessLevel: 0.5,
                universalStart: true
            };
            case 'cafe': return {
                path: AssetPaths.cafe__tmx,
                type: 'room',
                sounds: [4, 6],
                darknessLevel: 0.1
            };
            case 'back-room': return {
                path: AssetPaths.back_room__tmx,
                type: 'room',
                sounds: [6],
                darknessLevel: 0.1
            };
            case 'alley': return {
                path: AssetPaths.alley__tmx,
                type: 'room',
                sounds: [4],
                darknessLevel: 0.7,
                universalStart: true
            };
            case 'club-front': return {
                path: AssetPaths.club_front__tmx,
                type: 'outdoor',
                sounds: [3, 4, 7],
                darknessLevel: 0.5
            };
            case 'dock': return {
                path: AssetPaths.dock__tmx,
                type: 'outdoor',
                sounds: [0, 2],
                darknessLevel: 0.7
            };
            default: return null;
        }
    }
}
