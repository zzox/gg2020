package actors;

import data.GlobalState;
import data.NPCs.NPCData;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import scenes.PlayState;

// new class to attach a name to the sprite
class ThoughtBubble extends FlxSprite {
	public var name:String;
	public var fromNPC:String;
	public var popped:Bool = false;
	public function new (x, y, name, fromNPC) {
		super(x, y);
		this.name = name;
		this.fromNPC = fromNPC;
	}
}

class NPC extends FlxSprite {
	static final TALK_DISTANCE = 8;
	public var name:String;
	var follow:Bool;
	var canTalk:Bool;
	var _scene:PlayState;

	public var _bubbles:Null<FlxSprite>;
	public var _thoughtBubble:Null<ThoughtBubble>;
	public var _thoughtBubbleBackground:Null<FlxSprite>;

	public var _upArrow:FlxSprite;

	public function new (x:Float, y:Float, scene:PlayState, name:String, npcData:NPCData) {
		super(x, y);

		loadGraphic(npcData.graphic, true, 16, 24);
		offset.set(4, 7);
		setSize(11, 13);

		this.name = name;
		_scene = scene;

		follow = npcData.follow;
		flipX = npcData.flipX;
		canTalk = npcData.canTalk();

		_upArrow = new FlxSprite(x - 4, y - 16, AssetPaths.up_arrow__png);
		_upArrow.visible = false;
		FlxTween.tween(_upArrow, {y: _upArrow.y + 2}, 1, { type: FlxTweenType.PINGPONG, ease: FlxEase.sineInOut });

		if (npcData.bubble != null && npcData.bubble.qualify()) {
			// we add the bubble if it was completed but only if it wasn't JUST completed
			if (!GlobalState.instance.completedWorlds.contains(npcData.bubble.world) ||
				GlobalState.instance.currentWorld == npcData.bubble.world) {
				if (npcData.bubble.dir == 'right') {
					_bubbles = new FlxSprite(x + 8, y - 12);
					_bubbles.loadGraphic(AssetPaths.thought_bubbles__png, true, 16, 16);

					_thoughtBubble = new ThoughtBubble(x + 24, y - 20, npcData.bubble.world, name);
					_thoughtBubble.loadGraphic(AssetPaths.thought_cloud__png, true, 16, 16);

					_thoughtBubbleBackground = new FlxSprite(x + 24, y - 20);
					_thoughtBubbleBackground.loadGraphic(npcData.bubble.background, true, 16, 16);
				} else {
					_bubbles = new FlxSprite(x - 16, y - 12);
					_bubbles.loadGraphic(AssetPaths.thought_bubbles__png, true, 16, 16);
					_bubbles.flipX = true;

					_thoughtBubble = new ThoughtBubble(x - 32, y - 20, npcData.bubble.world, name);
					_thoughtBubble.loadGraphic(AssetPaths.thought_cloud__png, true, 16, 16);

					_thoughtBubbleBackground = new FlxSprite(x - 32, y - 20);
					_thoughtBubbleBackground.loadGraphic(npcData.bubble.background, true, 16, 16);
				}
			}
		}

		if (_bubbles != null) {
			_bubbles.animation.add('idle', [0, 1, 2, 3], 4);
			_bubbles.animation.add('pop', [4, 5, 6, 7], 4, false);
			_bubbles.animation.finishCallback = finishPopAnims;
			_bubbles.animation.play('idle');
		}

		if (_thoughtBubble != null) {
			_thoughtBubble.animation.add('idle', [0, 1, 2], 4);
			_thoughtBubble.animation.add('pop', [3, 4, 5, 6], 4);
			_thoughtBubble.animation.play('idle');
		}

		if (_thoughtBubbleBackground != null) {
			_thoughtBubbleBackground.animation.add('idle', [0, 1, 2], 4);
			_thoughtBubbleBackground.animation.add('pop', [3, 4, 5, 6], 4);
			_thoughtBubbleBackground.animation.play('idle');
		}

		animation.add('stand', [0]);
		animation.add('walk', [1, 1, 0, 2, 2, 0], 7);
		animation.add('run', [1, 1, 0, 2, 2, 0], 10);
		animation.add('breathe', [0, 0, 0, 3, 4, 4, 3], 8);

		animation.play('stand');
	}

	override function update (elapsed:Float) {
		if (follow && _scene._cinematic == null) {
			if (x > _scene._player.x) {
				flipX = true;
			} else {
				flipX = false;
			}
		}

		_upArrow.x = x - 4;

		if (Math.abs(_scene._player.x - x) < TALK_DISTANCE && canTalk && _scene._cinematic == null) {
			_upArrow.visible = true;
			if (FlxG.keys.justPressed.UP) {
				_scene.launchCinematic('$name-talk');
			}
		} else {
			_upArrow.visible = false;
		}

		super.update(elapsed);
	}

	public function popBubbles () {
		_bubbles.animation.play('pop');
		_thoughtBubble.animation.play('pop');
		_thoughtBubbleBackground.animation.play('pop');
	}

	function finishPopAnims (animName:String) {
		if (animName == 'pop') {
			_bubbles.visible = false;
			_thoughtBubble.visible = false;
			_thoughtBubbleBackground.visible = false;
		}
	}
}
