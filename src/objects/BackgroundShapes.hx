package objects;

import flixel.FlxSprite;
import flixel.group.FlxGroup;

class BackgroundShapes extends FlxGroup {
	static inline final GAME_WIDTH = 240;
	static inline final GAME_HEIGHT = 135;
	static inline final SHAPES_LENGTH = 5;

	public function new (colors:Array<Int>) {
		super();

		for (_ in 0...20) {
			add(genSprite(colors));
		}
	}

	override function update (elapsed:Float) {
		forEachOfType(FlxSprite, (item:FlxSprite) -> {
			if (item.x < -32) {
				item.x = GAME_WIDTH + 32;
			} else if (item.y < -32) {
				item.y = GAME_HEIGHT + 32;
			} else if (item.x > GAME_WIDTH + 32) {
				item.x = -32;
			} else if (item.y > GAME_HEIGHT + 32) {
				item.y = -32;
			}

			item.angle += (Math.abs(item.velocity.x) + Math.abs(item.velocity.y)) / 40;
		});

		super.update(elapsed);
	}

	function genSprite (colors:Array<Int>):FlxSprite {
		var spr = new FlxSprite(Math.random() * GAME_WIDTH, Math.random() * GAME_HEIGHT);
		spr.loadGraphic(AssetPaths.shapes__png, true, 16, 16);
		spr.animation.add('random', [Math.floor(Math.random() * SHAPES_LENGTH)]);
		spr.animation.play('random');
		spr.velocity.set(randomVel(), randomVel());
		spr.color = colors[Math.floor(Math.random() * colors.length)];
		var scale = Math.random() > 0.5 ? 2 : 1;
		spr.scale.set(scale, scale);
		spr.scrollFactor.set(0, 0);

		return spr;
	}

	function randomVel ():Float {
		return (20 + Math.random() * 60) * (Math.random() > 0.5 ? 1 : -1);
	}
}