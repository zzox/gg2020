import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxSprite;

typedef HoldsObj = {
	var left:Float;
	var right:Float;
	var up:Float; // remove?
	var down:Float; // remove?
	var jump:Float;
}

class Player extends FlxSprite {
	var holds:HoldsObj;

	public var hurting:Bool;
	public var hurtTime:Float;

	var jumping:Bool;
	var jumpTime:Float;

	public var deadTime:Float;

	var hasDashed:Bool;
	public var dashingTime:Float;

	var _scene:PlayState;

	static inline final JUMP_VELOCITY = 120;
	static inline final RUN_ACCELERATION = 1500;
	static inline final HIT_JUMP_DISTANCE = 10;
	static inline final HIT_JUMP_MIN_Y = 8;
	static inline final HIT_JUMP_MAX_Y = 16; // shouldn't be needed
	static inline final GRAVITY = 800;
	static inline final JUMP_START_TIME = 0.16;

	static inline final PRE_DASH = 0.1;
	static inline final DASH_TIME = 0.33;
	static inline final DASH_VELOCITY = 300;

	static inline final HURT_TIME = 1.25;
	static inline final REALLY_HURT = 0.5;
	public static inline final DEAD_TIME = 1.0;

	static final HURT_FLASHES:Array<Int> = [0, 1, 1, 0, 1, 1];
	static final REALLY_HURT_FLASHES:Array<Int> = [0, 0, 1, 1, 1, 1];
	var hurtFlashIndex:Int = 0;

	var airTime:Float;
	static inline final BUFFER_AIR_TIME = 0.1;

	public function new(x:Int, y:Int, scene:PlayState) {
		super(x, y);

		loadGraphic(AssetPaths.ty__png, true, 16, 24);
		offset.set(4, 7);
		setSize(11, 13);

		animation.add('stand', [0]);
		animation.add('run', [1, 1, 0, 2, 2, 0], 9);
		animation.add('in-air-down', [2, 3], 8);
		animation.add('in-air-up', [4, 5], 8);
		animation.add('breathe', [0, 0, 7], 8);

		maxVelocity.set(100, 150);

		holds = {
			left: 0,
			right: 0,
			up: 0,
			down: 0,
			jump: 0
		};

		hurting = false;
		jumping = false;
		hasDashed = false;
		jumpTime = 0.0;
		dashingTime = 0.0;
		deadTime = 0.0;

		_scene = scene;

		addDrag();
	}

	override public function update (elapsed:Float) {
		if (deadTime > 0) {
			deadTime -= elapsed;
			velocity.set(0, 0);
			acceleration.set(0, 0);
			color = 0x000000;
			animation.play('hurt');
			super.update(elapsed);

			return;
		}

		var reallyHurt = hurtTime > HURT_TIME - REALLY_HURT;
		if (hurting) {
			if (reallyHurt) {
				alpha = HURT_FLASHES[hurtFlashIndex];
			} else {
				alpha = REALLY_HURT_FLASHES[hurtFlashIndex];
			}

			hurtFlashIndex++;
			if (hurtFlashIndex == HURT_FLASHES.length) {
				hurtFlashIndex = 0;
			}

			// reset
			if (hurtTime < 0) {
				hurting = false;
				hurtFlashIndex = 0;
				alpha = 1;
			}
		}

		var touchingFloor = isTouching(FlxObject.DOWN);
		var vel = handleInputs(elapsed);

		if (!touchingFloor) {
			vel = vel * 2 / 3;
		}

		if ((dashingTime > 0 && touchingFloor) || reallyHurt) {
			vel = 0;
		}

		if (!reallyHurt && !(hurting && vel == 0) && dashingTime <= 0) {
			acceleration.set(vel * RUN_ACCELERATION, GRAVITY);
		}

		if (dashingTime > 0) {
			if (dashingTime < DASH_TIME - PRE_DASH) {
				if (flipX) {
					vel = -1;
                } else {
					vel = 1;
				}

				velocity.set(vel * DASH_VELOCITY, 0);
			} else {
				velocity.set(0, 0);
			}
		}

		hurtTime -= elapsed;
		jumpTime -= elapsed;
		dashingTime -= elapsed;

		var jumpPressed = FlxG.keys.anyJustPressed([Z, SPACE]);
		var dashPressed = FlxG.keys.anyJustPressed([X, TAB]);

		if (!reallyHurt) {
			if (jumpPressed && (touchingFloor || (airTime < BUFFER_AIR_TIME && !jumping))/* && dashingTime < 0*/) {
				jumping = true;
				jumpTime = JUMP_START_TIME;
			}

			if (jumping) {
				velocity.y = -JUMP_VELOCITY;

				if (!FlxG.keys.anyPressed([Z, SPACE]) || jumpTime <= 0 || (touchingFloor && jumpTime != JUMP_START_TIME)) {
					jumping = false;
					jumpTime = 0;
				}
			}

			if (dashPressed && dashingTime < 0 && !hasDashed && hurtTime <= 0.0) {
				dashingTime = DASH_TIME;
				hasDashed = true;
			}
		}

		if (dashingTime <= 0.0) {
			if (flipX && acceleration.x > 0) {
				flipX = false;
			}

			if (!flipX && acceleration.x < 0) {
				flipX = true;
			}
		}

		if (reallyHurt) {
			drag.set(0, 0);
		} else {
			// TODO: add drag ONLY when the user interacts with the game,
			// not when `reallyHurt` is over, or when player touches the ground
			addDrag();
		}

		if (touchingFloor) {
			if (dashingTime <= 0) {
				hasDashed = false;
			}
			airTime = 0;
		} else {
			airTime += elapsed;
		}

		handleDash();
		handleAnimation(touchingFloor);

		super.update(elapsed);
	}

	function handleInputs (elapsed:Float):Float {
		var vel:Float = 0.0;
		if (FlxG.keys.pressed.LEFT) {
			vel = -1;
			holds.left += elapsed;
		} else {
			holds.left = 0;
		}

		if (FlxG.keys.pressed.RIGHT) {
			vel = 1;
			holds.right += elapsed;
		} else {
			holds.right = 0;
		}

		if (FlxG.keys.pressed.UP) {
			holds.up += elapsed;
		} else {
			holds.up = 0;
		}

		if (FlxG.keys.pressed.DOWN) {
			holds.down += elapsed;
		} else {
			holds.down = 0;
		}

		if (FlxG.keys.anyPressed([Z, SPACE])) {
			holds.jump += elapsed;
		} else {
			holds.jump = 0;
		}

		if (FlxG.keys.pressed.LEFT && FlxG.keys.pressed.RIGHT) {
			if (holds.right > holds.left) {
				vel = -1;
			} else {
				vel = 1;
			}
		}

		return vel;
	}

	function handleAnimation (touchingFloor:Bool) {
		if (dashingTime > 0) {
			if (dashingTime < DASH_TIME - PRE_DASH) {
				animation.play('dash');
			} else {
				animation.play('setup');
			}

			return;
		}

		if (touchingFloor) {
			if (velocity.x != 0.0) {
				animation.play('run');
			} else {
				animation.play('stand');
			}
		} else {
			if (velocity.y > 20) {
				animation.play('in-air-down');
			} else {
				animation.play('in-air-up');
			}
		}
	}

	function handleDash () {
		if (dashingTime > 0 && dashingTime < DASH_TIME - PRE_DASH) {
            // handle overlap enemies here
		}
    }

	function addDrag () {
		drag.set(1500, 0);
	}
}
