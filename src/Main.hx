import flixel.FlxGame;
import openfl.display.Sprite;
import scenes.PlayState;

class Main extends Sprite {
	public function new() {
		super();
		addChild(new FlxGame(240, 135, PlayState, 1, 60, 60, true));
	}
}
