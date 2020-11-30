package data;

class GlobalState {
    public static final instance:GlobalState = new GlobalState();

    public var items:Array<String> = [];
    public var completedWorlds:Array<String> = [];
    public var completedXCinematics:Array<String> = [];
    public var currentRoom:String;
    public var lastRoom:Null<String>;
    public var currentWorld:Null<String>;
    public var fromWorld:Bool = false;
    public var wonWorld:Bool = false;

    public var momIsSleeping:Bool = false;
    public var offeredJoyPills:Bool = false;
    public var chrisLeftForTickets:Bool = false;
    public var informedByOldWoman:Bool = false;
    public var dancingWomanCalledGrandma:Bool = false;
    public var creepsAreInBack:Bool = false;

    private function new () {
        currentRoom = 'ty-room';
        lastRoom = null;
        currentWorld = null;
    }
}
