import flixel.FlxGame;
import openfl.display.Sprite;
import scenes.LoadState;

class Main extends Sprite {
	public function new() {
		super();
		addChild(new FlxGame(240, 135, LoadState, 1, 60, 60, true));
	}
}
