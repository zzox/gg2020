package data;

import haxe.Constraints.Function;

typedef Cinematic = {
	var type:String;
	var ?text:String;
	var ?callback:Function;
	var ?roomName:String;
	var ?item:String;
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
				text: 'hey!'
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
					anim: 'run'
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
				text: 'how did you get out?'
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'she "trusts" you?'
			}, {
				type: 'text',
				text: 'wow'
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'good one mom'
			}];
			case 'chris-tickets': return [{
				type: 'text',
				text: 'dude...'
			}, {
				type: 'text',
				text: 'don\'t be mad...'
			}, {
				type: 'text',
				text: 'i forgot the tickets!'
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'i swear i\'ll make it up to you'
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'you think we can find some?'
			}, {
				type: 'text',
				text: 'let\'s split up!'
			}, {
				type: 'actions',
				time: 2.0,
				actions: [{
					target: 'chris',
					type: 'move-x',
					to: { x: 265 }
				}, {
					target: 'chris',
					type: 'flip-x',
					flipX: false
				}, {
					target: 'chris',
					type: 'anim',
					anim: 'run'
				}]
			}, {
				type: 'callback',
				callback: () -> {
					GlobalState.instance.chrisLeftForTickets = true;
					return -1;
				}
			}];
			case 'back-room': return [{
				type: 'callback',
				callback: () -> {
					if (GlobalState.instance.creepsAreInBack) {
						return 1;
					}

					return 3;
				}
			}, {
				type: 'room-change',
				text: 'It\'s locked'
			}, {
				type: 'room-change',
				roomName: 'back-room'
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
			case 'old-woman-thought-win': return [{
				type: 'text',
				text: 'sorry if i seem uspet'
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'i haven\'t heard from my grandkids in months'
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'i think i hear the bus coming'
			}, {
				type: 'room-change',
				roomName: 'bus'
			}];
			case 'joy-thought-win': return [{
				type: 'text',
				text: 'who are you seeing?'
			}, {
				type: 'text',
				text: 'DJ Hellgirl?'
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'i guess i can give you a ride'
			}, {
				type: 'text',
				text: 'get your friend and get in the car'
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'you have surpirisingly good taste'
			}, {
				type: 'room-change',
				roomName: 'downtown'
			}];
			case 'busdriver-thought-win': return [{
				type: 'text',
				text: 'final stop, seaside city center'
			}, {
				type: 'text',
				text: '...'
			}, {
				type: 'text',
				text: 'man i love my job'
			}, {
				type: 'room-change',
				roomName: 'downtown'
			}];
			case 'bouncer-one-thought-win': return [{
				type: 'text',
				text: 'you seem like a chill kid'
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'take this'
			}, {
				type: 'item',
				item: 'a beer'
			}];
			// dialog
			case 'chris-talk': return [{
				type: 'callback',
				callback: () -> {
					if (GlobalState.instance.currentRoom == 'bus') {
						return 1;
					}

					if (GlobalState.instance.currentRoom == 'hometown') {
						return 4;
					}

					return -1;
				}
			}, {
				type: 'text',
				text: 'i\'m so excited'
			}, {
				type: 'text',
				text: 'do you think she\'ll drop that \'Til Death remix?'
			}, {
				type: 'callback',
				callback: () -> -1
			}, {
				type: 'text',
				text: 'still want to catch the bus?'
			}, {
				type: 'text',
				text: 'because i see Joy is outside her house'
			}, {
				type: 'text',
				text: 'maybe she\'ll give us a ride instead'
			}, {
				type: 'callback',
				callback: () -> {
					if (GlobalState.instance.items.contains('pills')) {
						return 8;
					}

					return -1;
				}
			}, {
				type: 'text',
				text: 'maybe you can give her some of your study meds'
			}, {
				type: 'text',
				text: 'you never take them anyway'
			}];
			case 'joy-talk': return [{
				type: 'callback',
				callback: () -> {
					var gs = GlobalState.instance;
					if (gs.currentRoom == 'hometown') {
						if (GlobalState.instance.offeredJoyPills) {
							return 3;
						}

						return 1;
					}

					if (gs.creepsAreInBack) {
						return 8;
					}

					return 11;
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
			}, {
				type: 'callback',
				callback: () -> {
					GlobalState.instance.offeredJoyPills = true;
					return -1;
				}
			}, {
				type: 'text',
				text: 'damn, that\'s a lesson for you'
			}, {
				type: 'text',
				text: 'become a musician'
			}, {
				type: 'callback',
				callback: () -> {
					GlobalState.instance.offeredJoyPills = true;
					return -1;
				}
			}, {
				type: 'text',
				text: 'wow look at him'
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'no, the tall one'
			}, {
				type: 'text',
				text: 'should i talk to him?'
			}];
			case 'old-woman-talk': return [{
				type: 'callback',
				callback: () -> {
					if (GlobalState.instance.currentRoom == 'bus') {
						return 1;
					}

					if (GlobalState.instance.currentRoom == 'hometown') {
						return 4;
					}

					return -1;
				}
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'what\'s with all the jumping?'
			}, {
				type: 'callback',
				callback: () -> -1
			}, {
				type: 'text',
				text: '... ...',
			}, {
				type: 'text',
				text: 'kids out late can\'t be up to anything good'
			}];
			case 'bouncer-one-talk': return [{
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'you can never be too cool for public transportation'
			}];
			case 'bouncer-two-talk': return [{
				type: 'text',
				text: 'it\'s like, 8 pm'
			}, {
				type: 'text',
				text: 'why are you at a show so early?'
			}];
			case 'dancing-woman-talk': return [{
				type: 'text',
				text: 'She\'s just dancing.',
			}];
			default: return null;
		}
	}
}
