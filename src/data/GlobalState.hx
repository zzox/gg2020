package data;

class GlobalState {
    public static final instance:GlobalState = new GlobalState();

    public var items:Array<String>;
    public var completedWorlds:Array<String>;
    public var completedXCinematics:Array<String>;
    public var currentRoom:String;
    public var lastRoom:Null<String>;
    public var currentWorld:Null<String>;
    public var fromWorld:Bool;
    public var wonWorld:Bool;

    public var momIsSleeping:Bool;
    public var offeredJoyPills:Bool;
    public var chrisLeftForTickets:Bool;
    public var informedByOldWoman:Bool;
    public var dancingWomanCalledGrandma:Bool;
    public var creepsAreInBack:Bool;

    private function new () {
        restart();
    }

    public function restart() {
        currentRoom = 'ty-room';
        lastRoom = null;
        currentWorld = null;

        items = [];
        completedWorlds = [];
        completedXCinematics = [];
        fromWorld = false;
        wonWorld = false;

        momIsSleeping = false;
        offeredJoyPills = false;
        chrisLeftForTickets = false;
        informedByOldWoman = false;
        dancingWomanCalledGrandma = false;
        creepsAreInBack = false;
    }
}
