package actors;

import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;

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

	var inThoughts:Bool;
	var hasDashed:Bool;
	public var dashingTime:Float;
	public var hasHitFloor:Bool;
	public var frozen:Bool;
	public var dead:Bool;
	public var presenting:Bool;
	public var launched:Bool;

	var _scene:Dynamic;

	static inline final JUMP_VELOCITY = 120;
	static inline final RUN_ACCELERATION = 1500;
	static inline final HIT_JUMP_DISTANCE = 10;
	static inline final HIT_JUMP_MIN_Y = 8;
	static inline final HIT_JUMP_MAX_Y = 16; // shouldn't be needed
	static inline final GRAVITY = 800;
    static inline final JUMP_START_TIME = 0.16;
    static inline final AIR_DOWN_ANIM_LIMIT = 50;

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
	static inline final AIR_TIME_BUFFER = 0.1;

	var _jumpSound:FlxSound;
	var _landSound:FlxSound;
	var _dashSound:FlxSound;

	var prevTouchingFloor:Null<Bool> = null;

	public function new(x:Float, y:Float, scene:Dynamic, inThoughts:Bool, fromRight:Bool) {
		super(x, y);

		loadGraphic(AssetPaths.ty__png, true, 16, 24);
		offset.set(4, 7);
		setSize(8, 13);

		animation.add('stand', [0]);
		animation.add('run', [1, 1, 0, 2, 2, 0], 9);
		animation.add('in-air-down', [2, 3], 8);
		animation.add('in-air-up', [4, 5], 8);
		animation.add('breathe', [0, 0, 6], 8);
		animation.add('pre-dash', [9]);
		animation.add('dash', [6, 7, 7], 16);
		animation.add('frozen', [4]);
		animation.add('present', [10]);
		animation.add('dead', [11]);

		maxVelocity.set(60, 150);

		holds = {
			left: 0,
			right: 0,
			up: 0,
			down: 0,
			jump: 0
		};

		hurting = false;
		dead = false;
		jumping = false;
		hasDashed = false;
		hasHitFloor = false;
		frozen = false;
		presenting = false;
		launched = false;
		jumpTime = 0.0;
		dashingTime = 0.0;
		deadTime = 0.0;

		_scene = scene;
		this.inThoughts = inThoughts;

		if (fromRight) {
			flipX = true;
		}

		addDrag();

		_jumpSound = FlxG.sound.load(AssetPaths.jump__wav, 0.5);
		_landSound = FlxG.sound.load(AssetPaths.land__wav, 0.25);
		_dashSound = FlxG.sound.load(AssetPaths.dash__wav, 0.5);
	}

	override public function update (elapsed:Float) {
		if (dead) {
			velocity.set(0, 0);
			acceleration.set(0, 0);
			animation.play('dead');
			super.update(elapsed);

			return;
		}

		if (frozen) {
			velocity.set(0, 0);
			acceleration.set(0, 0);
			color = 0xffffff;
			animation.play('frozen');
			super.update(elapsed);

			return;
		}

		if (deadTime > 0) {
			deadTime -= elapsed;
			velocity.set(0, 0);
			acceleration.set(0, 0);
			color = 0x000000;
			animation.play('hurt');
			super.update(elapsed);

			return;
		}

		var touchingFloor = isTouching(FlxObject.DOWN);
		var vel = handleInputs(elapsed);

		if (_scene.worldStatus != null) {
			handleAnimation(touchingFloor);
			acceleration.set(0, GRAVITY);
			super.update(elapsed);
			return;
		}

		if (!hasHitFloor && isTouching(FlxObject.DOWN)) {
			hasHitFloor = true;
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

		if (!touchingFloor) {
			vel = vel * 2 / 3;
		}

		if ((dashingTime > 0 && touchingFloor) || reallyHurt || _scene._cinematic != null) {
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

        // WARN: best way to do this?
        if (_scene._cinematic != null) {
            jumpPressed = false;
            dashPressed = false;
        }

		if (!reallyHurt) {
			if (!launched && jumpPressed && (touchingFloor || (airTime < AIR_TIME_BUFFER && !jumping))
				&& dashingTime < 0 && !_scene.justSubmitted) {
				jumping = true;
				jumpTime = JUMP_START_TIME;
				_jumpSound.play();
			}

			if (jumping) {
				velocity.y = -JUMP_VELOCITY;

				if (!FlxG.keys.anyPressed([Z, SPACE]) || jumpTime <= 0 || (touchingFloor && jumpTime != JUMP_START_TIME)) {
					jumping = false;
					jumpTime = 0;
				}
			}

			if (dashPressed && dashingTime < 0 && !hasDashed && hurtTime <= 0.0 && inThoughts) {
				_dashSound.play();
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
			if (!launched) {
				addDrag();
			}
		}

		if (touchingFloor) {
			if (dashingTime <= 0) {
				hasDashed = false;
			}
			airTime = 0;
		} else {
			airTime += elapsed;
		}

		if (touchingFloor && prevTouchingFloor == false && !launched) {
			_landSound.play();
		}

		prevTouchingFloor = touchingFloor;

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
		if (presenting) {
			animation.play('present');
			return;
		}

		if (dashingTime > 0) {
			if (dashingTime < DASH_TIME - PRE_DASH) {
				animation.play('dash');
			} else {
				animation.play('pre-dash');
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
			if (velocity.y > AIR_DOWN_ANIM_LIMIT) {
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
