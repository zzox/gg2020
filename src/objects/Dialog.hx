package objects;

import flixel.FlxG;
import flash.geom.Rectangle;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.group.FlxGroup;
import flixel.text.FlxBitmapText;
import haxe.Constraints.Function;
import openfl.Assets;

class Dialog extends FlxGroup {
    public var open:Bool;
    var onComplete:Function;

    var bg:FlxUI9SliceSprite;
    var _textLine:FlxBitmapText;

    var textTime:Float;
    var stepTime:Float;
    var textIndex:Int;
    var text:String;
    var halted:Bool;

    static inline final TEXT_COLOR = 0xff151515;

    public function new (onComplete:Function, text:String) {       
        super();
        
        var _graphic = AssetPaths.menu__png;
        var _slice = [4, 4, 8, 8];
        
        this.onComplete = onComplete;
        
        bg = new FlxUI9SliceSprite(0, 0, _graphic, new Rectangle(0, 0, 240, 20), _slice);
        bg.scrollFactor.set(0, 0);

        var textBytes = Assets.getText(AssetPaths.miniset__fnt);
        var XMLData = Xml.parse(textBytes);
        var fontAngelCode = FlxBitmapFont.fromAngelCode(AssetPaths.miniset__png, XMLData);

        _textLine = new FlxBitmapText(fontAngelCode);
        _textLine.letterSpacing = -1;
        _textLine.color = TEXT_COLOR;
        _textLine.setPosition(6, 5);
        _textLine.scrollFactor.set(0, 0);

        stepTime = 0.1;
        textTime = 0;
        textIndex = 0;
        halted = false;

        this.text = text;
        open = true;

        add(bg);
        add(_textLine);
    }

    override public function update (elapsed:Float) {
        if (!open) {
            return;
        }

        if (!halted) {
            if (FlxG.keys.anyJustPressed([X, Z, SPACE])) {
                fill();
            } else {   
                textTime += elapsed;

                if (textTime > stepTime) {
                    textTime -= stepTime;

                    addLetter();
                }
            }
        } else {
            if (FlxG.keys.anyJustPressed([X, Z, SPACE])) {
                end();
            }
        }
    }

    function addLetter() {
        // skip spaces
        if (text.charAt(textIndex) == ' ') {
            _textLine.text += ' ';
            textIndex++;
        }

        if (textIndex > text.length) {
            halted = true;
        } else {
            _textLine.text += text.charAt(textIndex);
        }

        textIndex++;
    }

    function fill () {
        _textLine.text = text;
        halted = true;
    }

    function start () {
        halted = false;
        visible = true;
    }

    function end () {
        onComplete();
        visible = false;
    }
}