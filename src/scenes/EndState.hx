package scenes;

import flixel.system.FlxSound;
import data.GlobalState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.scaleModes.PixelPerfectScaleMode;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import flixel.tweens.FlxTween;
import objects.BackgroundShapes;
import openfl.Assets;

class EndState extends FlxState {
	static inline final GAME_WIDTH = 240;
    static inline final GAME_HEIGHT = 135;
    
    var worldStatus:Null<Bool> = null;
    var sound:FlxSound;
    var _filter:FlxSprite;

	override public function create() {
        FlxG.mouse.visible = false;

		FlxG.scaleMode = new PixelPerfectScaleMode();

		// camera.followLerp = 0.5;

        bgColor = 0xffffffff;
        
		var _colorFilter = new FlxSprite();
		_colorFilter.makeGraphic(GAME_WIDTH, GAME_HEIGHT, 0xffff82ce);
		_colorFilter.alpha = 0.7;
		_colorFilter.scrollFactor.set(0, 0);
        add(_colorFilter);
        
		_filter = new FlxSprite(0, 0);
		_filter.makeGraphic(GAME_WIDTH, GAME_HEIGHT, 0xff151515);
		_filter.scrollFactor.set(0, 0);

        add(new BackgroundShapes([0xffffffff, 0xff024aca, 0xff7b7b7b]));
        
		add(_filter);

        var textBytes = Assets.getText(AssetPaths.miniset__fnt);
        var XMLData = Xml.parse(textBytes);
        var fontAngelCode = FlxBitmapFont.fromAngelCode(AssetPaths.miniset__png, XMLData);

        var _textLine1 = new FlxBitmapText(fontAngelCode);
        _textLine1.letterSpacing = -1;
        _textLine1.color = 0xff151515;
        _textLine1.setPosition(54, 24);
        _textLine1.text = 'art, music and code';
        _textLine1.alpha = 0;
        _textLine1.scale.set(2, 2);
        add(_textLine1);

        var _textLine2 = new FlxBitmapText(fontAngelCode);
        _textLine2.letterSpacing = -1;
        _textLine2.color = 0xff151515;
        _textLine2.setPosition(96, 50);
        _textLine2.text = 'by zzox (tyler)';
        _textLine2.alpha = 0;
        _textLine2.scale.set(2, 2);
        _textLine2.borderSize = 2;
        _textLine2.borderColor = 0xffffffff;
        add(_textLine2);

        var _textLine3 = new FlxBitmapText(fontAngelCode);
        _textLine3.letterSpacing = -1;
        _textLine3.color = 0xff151515;
        _textLine3.setPosition(72, 108);
        _textLine3.text = 'press SPACE to restart';
        _textLine3.alpha = 0;
        add(_textLine3);

		worldStatus = false;
		FlxTween.tween(_filter, { alpha: 0 }, 0.5);
        FlxTween.tween(_textLine1, { alpha: 1 }, 0.5, { startDelay: 2.5 });
        FlxTween.tween(_textLine2, { alpha: 1 }, 0.5, { startDelay: 4.5 });
        FlxTween.tween(_textLine3, { alpha: 1 }, 0.1, { startDelay: 8.0, onComplete: (_:FlxTween) -> {
            worldStatus = true;
        }});

        // fade in ending song
        sound = FlxG.sound.play(AssetPaths.ending__wav, 0, true, FlxG.sound.defaultMusicGroup);
        FlxTween.tween(sound, { volume: 1 }, 1.5);
    }

	override public function update(elapsed:Float) {
		super.update(elapsed);

        if (worldStatus == true && FlxG.keys.justPressed.SPACE) {
            // restart game
            worldStatus = null;
            FlxTween.tween(sound, { volume: 0 }, 0.95);
            FlxTween.tween(_filter, { alpha: 1 }, 1.0, { onComplete: (_:FlxTween) -> {
                GlobalState.instance.restart();
                FlxG.switchState(new PlayState());
            }});
        }
    }
}