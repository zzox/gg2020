class GlobalState {
    public static final instance:GlobalState = new GlobalState();

    public var currentRoom:String;
    public var lastRoom:Null<String>;
    public var currentWorld:Null<String>;

    public var momIsSleeping:Bool = false;

    private function new () {
        currentRoom = 'ty-room';
        lastRoom = null;
        currentWorld = null;
    }
}
