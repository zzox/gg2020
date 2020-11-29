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

    private function new () {
        currentRoom = 'downtown';
        lastRoom = null;
        currentWorld = null;
    }
}
