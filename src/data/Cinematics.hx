package data;

import haxe.Constraints.Function;

typedef Cinematic = {
	var type:String;
	var ?text:String;
	var ?callback:Function;
	var ?roomName:String;
	var ?actions:Array<Action>;
	var ?time:Float;
}

typedef Action = {
	var target:String;
	var type:String;
	var ?to:OptPoint;
	var ?anim:String;
	var ?visibility:Bool;
	var ?flipX:Bool;
}

typedef OptPoint = {
	var ?x:Float;
	var ?y:Float;
}

class Cinematics {
	static public function getCinematic (name:String):Null<Array<Cinematic>> {
		switch (name) {
			// events
			case 'leave-house': return [{
				type: 'callback',
				callback: () -> {
					if (GlobalState.instance.momIsSleeping) {
						return 4;
					} else {
						return 1;
					}
				}
			}, {
				type: 'text',
				text: 'What are you doing? It\'s way too late.'
			}, {
				type: 'text',
				text: 'You should be in bed.'
			}, {
				type: 'room-change',
				roomName: 'ty-room'
			}, {
				type: 'room-change',
				roomName: 'hometown'
			}];
			case 'chris-intro': return [{
				type: 'text',
				text: 'Hey!'
			}, {
				type: 'actions',
				time: 2.0,
				actions: [{
					target: 'chris',
					type: 'move-x',
					to: { x: 154 }
				}, {
					target: 'chris',
					type: 'anim',
					anim: 'walk'
				}]
			}, {
				type: 'actions',
				time: 0.0,
				actions: [{
					target: 'chris',
					type: 'anim',
					anim: 'stand'
				}, {
					target: 'chris',
					type: 'flip-x',
					flipX: true
				}]
			}, {
				type: 'text',
				text: 'How did you get out?'
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'She "Trusts" you?'
			}, {
				type: 'text',
				text: 'wow'
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'Good one mom'
			}];
			// wins
			case 'mom-thought-win': return [{
				type: 'text',
				text: 'I\'m going to sleep.'
			}, {
				type: 'text',
				text: 'You should really be in bed.'
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'I trust you.'
			}, {
				type: 'actions',
				time: 1.0,
				actions: [{
					target: 'mom',
					type: 'move-x',
					to: { x: 114 }
				}, {
					target: 'mom',
					type: 'anim',
					anim: 'walk'
				}]
			}, {
				type: 'actions',
				time: 0,
				actions: [{
					target: 'mom',
					type: 'visibility',
					visibility: false
				}]
			}, {
				type: 'callback',
				callback: () -> {
					GlobalState.instance.momIsSleeping = true;
					return -1;
				}
			}];
			// dialog
			case 'chris-talk': return [{
				type: 'text',
				text: 'still want to catch the bus?'
			}, {
				type: 'text',
				text: 'Joy is outside her house'
			}, {
				type: 'text',
				text: 'maybe she\'ll give us a ride'
			}, {
				type: 'callback',
				callback: () -> {
					if (GlobalState.instance.items.contains('pills')) {
						return 4;
					}

					return -1;
				}
			}, {
				type: 'text',
				text: 'maybe you can give her some of your study medication'
			}, {
				type: 'text',
				text: 'you never take it anyway'
			}];
			case 'joy-talk': return [{
				type: 'callback',
				callback: () -> {
					if (GlobalState.instance.offeredJoyPills) {
						return 3;
					}

					return 1;
				}
			}, {
				type: 'text',
				text: 'you\'re going into the city?'
			}, {
				type: 'callback',
				callback: () -> {
					if (GlobalState.instance.items.contains('pills')) {
						return 3;
					}

					return 5;
				}
			}, {
				type: 'text',
				text: 'ew, weirdo. why do you think i\'d want those'
			}, {
				type: 'callback',
				callback: () -> {
					GlobalState.instance.offeredJoyPills = true;
					return -1;
				}
			}, {
				type: 'text',
				text: 'eh i dunno'
			}, {
				type: 'text',
				text: 'aren\'t you, like, too young to be going out?'
			}];
			case 'old-woman-talk': return [{
				type: 'text',
				text: '... ...',
			}, {
				type: 'text',
				text: 'kids out late can\'t be up to anything good'
			}];
			default: return null;
		}
	}
}
