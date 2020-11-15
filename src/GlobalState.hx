class GlobalState {
    public static final instance:GlobalState = new GlobalState();

    public var completedWorlds:Array<String> = [];
    public var currentRoom:String;
    public var lastRoom:Null<String>;
    public var currentWorld:Null<String>;
    public var fromWorld:Bool = false;
    public var wonWorld:Bool = false;

    public var momIsSleeping:Bool = false;

    private function new () {
        currentRoom = 'ty-room';
        lastRoom = null;
        currentWorld = null;
    }
}
