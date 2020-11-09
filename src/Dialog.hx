import flash.geom.Rectangle;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.group.FlxGroup;
import flixel.text.FlxBitmapText;
import haxe.Constraints.Function;
import openfl.Assets;

class Dialog extends FlxGroup {
    public var open:Bool;
    // public var onTop:Bool;
    // public var justOpened:Bool;
    // public var highlighted:Int = 0;
    // public var items:Array<MenuItem>;
    var onComplete:Function;
    var bg:FlxUI9SliceSprite;
    // var selector:FlxSprite;
    // var columns:Int;

    var _textLine1:FlxBitmapText;
    var _textLine2:FlxBitmapText;

    var textTime:Float;
    var stepTime:Int;
    var textIndex:Int;
    var textLine:Int;
    var text:String;
    var halted:Bool;

    static inline final TEXT_COLOR = 0xff151515;

    public function new (onComplete:Function, text:String) {       
        super();
        
        var _graphic = AssetPaths.menu__png;
        var _slice = [4, 4, 8, 8];
        
        this.onComplete = onComplete;
        
        bg = new FlxUI9SliceSprite(0, 0, _graphic, new Rectangle(0, 0, 240, 48), _slice);

        var textBytes = Assets.getText(AssetPaths.miniset__fnt);
        var XMLData = Xml.parse(textBytes);
        var fontAngelCode = FlxBitmapFont.fromAngelCode(AssetPaths.miniset__png, XMLData);

        _textLine1 = new FlxBitmapText(fontAngelCode);
        _textLine1.color = TEXT_COLOR;
        _textLine1.setPosition(10, 10);

        _textLine2 = new FlxBitmapText(fontAngelCode);
        _textLine2.color = TEXT_COLOR;
        _textLine2.setPosition(10, 24);

        stepTime = 100;
        textTime = 0;
        textIndex = 0;
        textLine = 1;
        halted = false;
        visible = false;

        this.text = text;
        open = false;
    }

    override public function update (elapsed:Float) {
        trace('isupdating');
        if (!halted) {
            textTime += elapsed;

            if (textTime > stepTime) {
                textTime -= stepTime;

                addLetter();
            }
        }
    }

    function addLetter() {
        // chheck if is a space.


        // add letter to text line
        textIndex++;

        if (textIndex > text.length) {
            // halt
        }
    }

    function fill () {
        // while not halted, add letter.
    }

    function start () {
        // other stuff
        visible = true;
    }

    function end () {
        // other stuff
        visible = false;
    }
}