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
				type: 'callback',
				callback: () -> {
					GlobalState.instance.informedByOldWoman = true;
					return 7;
				}
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
				text: '... ...'
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
			case 'dancing-woman-thought-win': return [{
				type: 'text',
				text: 'wow'
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'i really should call my grandma'
			}, {
				type: 'actions',
				time: 1.25,
				actions: [{
					target: 'dancing-woman',
					type: 'move-x',
					to: { x: -16 }
				}, {
					target: 'dancing-woman',
					type: 'flip-x',
					flipX: true
				}, {
					target: 'dancing-woman',
					type: 'anim',
					anim: 'run'
				}]
			}, {
				type: 'callback',
				callback: () -> {
					GlobalState.instance.dancingWomanCalledGrandma = true;
					return -1;
				}
			}];
			case 'creep-one-thought-win': return [{
				type: 'text',
				text: 'i should definitely talk to her'
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'lemme see that beer kid'
			}, {
				type: 'actions',
				time: 2.0,
				actions: [{
					target: 'creep-one',
					type: 'anim',
					anim: 'drink'
				}]
			}, {
				type: 'actions',
				time: 1.0,
				actions: [{
					target: 'creep-one',
					type: 'anim',
					anim: 'run'
				}, {
					target: 'creep-one',
					type: 'move-x',
					to: { x: 72 }
				}, {
					target: 'creep-one',
					type: 'flip-x',
					flipX: true
				}]
			}, {
				type: 'actions',
				time: 2.0,
				actions: [{
					target: 'creep-one',
					type: 'anim',
					anim: 'stand'
				}]
			}, {
				type: 'actions',
				time: 2.0,
				actions: [{
					target: 'creep-one',
					type: 'move-x',
					to: { x: 20 },
				}, {
					target: 'creep-one',
					type: 'anim',
					anim: 'run'
				}]
			}, {
				type: 'actions',
				time: 0,
				actions: [{
					target: 'creep-one',
					type: 'visibility',
					visibility: false
				}]
			}, {
				type: 'actions',
				time: 1.5,
				actions: [{
					target: 'hellgirl',
					type: 'move-x',
					to: { x: 20 }
				}, {
					target: 'hellgirl',
					type: 'flip-x',
					flipX: true
				}, {
					target: 'hellgirl',
					type: 'anim',
					anim: 'run'
				}]
			}, {
				type: 'actions',
				time: 3.0,
				actions: [{
					target: 'hellgirl',
					type: 'visibility',
					visibility: false
				}]
			}, {
				type: 'actions',
				time: 2.0,
				actions: [{
					target: 'creep-two',
					type: 'move-x',
					to: { x: 20 }
				}, {
					target: 'creep-two',
					type: 'flip-x',
					flipX: true
				}, {
					target: 'creep-two',
					type: 'anim',
					anim: 'run'
				}]
			}, {
				type: 'actions',
				time: 0,
				actions: [{
					target: 'creep-two',
					type: 'visibility',
					visibility: false
				}]
			}, {
				type: 'callback',
				callback: () -> {
					GlobalState.instance.creepsAreInBack = true;
					return -1;
				}
			}];
			case 'creep-two-thought-win': return [{
				type: 'text',
				text: 'kid\'s weirding me out'
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'let\'s get out of here'
			}, {
				type: 'actions',
				time: 0.8,
				actions: [{
					target: 'creep-two',
					type: 'anim',
					anim: 'run'
				}, {
					target: 'creep-two',
					type: 'move-x',
					to: { x: 160 }
				}, {
					target: 'creep-two',
					type: 'flip-x',
					flipX: false
				}]
			}, {
				type: 'actions',
				time: 0,
				actions: [{
					target: 'creep-two',
					type: 'visibility',
					visibility: false
				}]
			}, {
				type: 'actions',
				time: 1.0,
				actions: [{
					target: 'creep-one',
					type: 'move-x',
					to: { x: 160 },
				}, {
					target: 'creep-one',
					type: 'anim',
					anim: 'run'
				}]
			}, {
				type: 'actions',
				time: 0,
				actions: [{
					target: 'creep-one',
					type: 'visibility',
					visibility: false
				}]
			}, {
				type: 'actions',
				time: 2.0,
				actions: [{
					target: 'hellgirl',
					type: 'flip-x',
					flipX: true
				}]
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'actions',
				time: 1.5,
				actions: [{
					target: 'hellgirl',
					type: 'move-x',
					to: { x: 160 }
				}, {
					target: 'hellgirl',
					type: 'anim',
					anim: 'run'
				}, {
					target: 'hellgirl',
					type: 'flip-x',
					flipX: false
				}]
			}, {
				type: 'actions',
				time: 0,
				actions: [{
					target: 'hellgirl',
					type: 'visibility',
					visibility: false
				}]
			}, {
				type: 'callback',
				callback: () -> {
					GlobalState.instance.creepsScaredOff = true;
					return -1;
				}
			}];
			// dialog
			case 'chris-talk': return [{
				type: 'callback',
				callback: () -> {
					var room = GlobalState.instance.currentRoom;
					if (room == 'bus') {
						return 1;
					}

					if (room == 'hometown') {
						return 4;
					}

					if (room == 'club-front') {
						return 11;
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
				text: 'you can offer her some of your study meds'
			}, {
				type: 'text',
				text: 'you never take them anyway'
			}, {
				type: 'callback',
				callback: () -> -1
			}, {
				type: 'text',
				text: 'i couldn\'t find any...'
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'YOU FOUND SOME?'
			}, {
				type: 'text',
				text: 'LETS DO THIS!'
			}, {
				type: 'end'
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
					var inst = GlobalState.instance;
					var room = inst.currentRoom;
					if (room == 'bus') {
						return 1;
					}

					if (room == 'hometown') {
						return 4;
					}

					if (room == 'dock') {
						if (inst.dancingWomanCalledGrandma && !inst.items.contains('ten bucks')) {
							return 14;
						}

						return 7;
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
			}, {
				type: 'callback',
				callback: () -> -1
			}, {
				type: 'text',
				text: 'sure is nice out here',
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'the sea air at night is unparalleled'
			}, {
				type: 'callback',
				callback: () -> { 
					if (!GlobalState.instance.informedByOldWoman) {
						GlobalState.instance.informedByOldWoman = true;
						return 11;
					}

					return -1;
				}
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'i just wish my grandkids would call once in a while'
			}, {
				type: 'callback',
				callback: () -> -1
			}, {
				type: 'text',
				text: 'you would never guess who just called'
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'that\'s right!'
			}, {
				type: 'text',
				text: 'such a nice surprise'
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'i overheard your friend talking about a concert?'
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'oh, no'
			}, {
				type: 'text',
				text: 'well here you go'
			}, {
				type: 'text',
				text: 'and be kind to your folks will you?'
			}, {
				type: 'item',
				item: 'ten bucks'
			}];
			case 'bouncer-one-talk': return [{
				type: 'callback',
				callback: () -> {
					if (GlobalState.instance.currentRoom == 'bus') {
						return 1;
					}

					return 3;
				}
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'you can never be too cool for public transportation'
			}, {
				type: 'callback',
				callback: () -> {
					var gs = GlobalState.instance;
					if (gs.currentRoom == 'bus') {
						return -1;
					}

					if (gs.items.contains('ten bucks')) {
						return 4;
					}

					if (gs.items.contains('tickets')) {
						return 7;
					}

					return 10;
				}
			}, {
				type: 'text',
				text: 'ten bucks? enough for two tickets'
			}, {
				type: 'text',
				text: 'your friend coming with? he\'s been bothering me'
			}, {
				type: 'callback',
				callback: () -> -1
			}, {
				type: 'text',
				text: 'well...'
			}, {
				type: 'text',
				text: 'those look like two tickets to me'
			}, {
				type: 'callback',
				callback: () -> -1
			}, {
				type: 'text',
				text: 'no ticket, no money, no entry'
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'sorry kid'
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
			case 'creep-one-talk': return [{
				type: 'callback',
				callback: () -> {
					if (GlobalState.instance.currentRoom == 'cafe') {
						return 1;
					}

					return 3;
				}
			}, {
				type: 'text',
				text: 'is she looking at me?'
			}, {
				type: 'callback',
				callback: () -> -1
			}];
			case 'creep-two-talk': return [{
				type: 'callback',
				callback: () -> {
					if (GlobalState.instance.currentRoom == 'cafe') {
						return 1;
					}

					return 3;
				}
			}, {
				type: 'text',
				text: 'i can\'t believe that\'s her'
			}, {
				type: 'callback',
				callback: () -> -1
			}];
			case 'hellgirl-talk': return [{
				type: 'callback',
				callback: () -> {
					var gs = GlobalState.instance;
					if (gs.currentRoom == 'cafe') {
						if (gs.talkedToHellgirl) {
							return 5;
						}

						return 1;
					}

					return 8;
				}
			}, {
				type: 'text',
				text: 'yes, i am DJ Hellgirl'
			}, {
				type: 'text',
				text: 'or just \'j\''
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'thank you for approaching and not just ogling'
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'sorry hun, gave my spare tickets to some friends'
			}, {
				type: 'callback',
				callback: () -> {
					GlobalState.instance.talkedToHellgirl = true;
					return -1;
				}
			}, {
				type: 'text',
				text: 'i can handle myself around those creeps ya know'
			}, {
				type: 'text',
				text: '... ...'
			}, {
				type: 'text',
				text: 'but i appreciate you looking out for me'
			}, {
				type: 'text',
				text: 'you\'re sweet'
			}, {
				type: 'text',
				text: '...'
			}, {
				type: 'actions',
				time: 1.0,
				actions: [{
					target: 'hellgirl',
					type: 'anim',
					anim: 'kiss'
				}]
			}, {
				type: 'actions',
				time: 1.5,
				actions: [{
					target: 'hellgirl',
					type: 'anim',
					anim: 'stand'
				}]
			}, {
				type: 'actions',
				time: 1.0,
				actions: [{
					target: 'hellgirl',
					type: 'move-x',
					to: { x: 160 }
				}, {
					target: 'hellgirl',
					type: 'anim',
					anim: 'run'
				}]
			}, {
				type: 'actions',
				time: 1.0,
				actions: [{
					target: 'hellgirl',
					type: 'flip-x',
					flipX: false
				}, {
					target: 'hellgirl',
					type: 'anim',
					anim: 'stand'
				}]
			}, {
				type: 'text',
				text: 'oh! wait!'
			}, {
				type: 'text',
				text: 'take these, my friends had to cancel'
			}, {
				type: 'actions',
				time: 2.0,
				actions: [{
					target: 'hellgirl',
					type: 'move-x',
					to: { x: -16 }
				}, {
					target: 'hellgirl',
					type: 'anim',
					anim: 'run'
				}, {
					target: 'hellgirl',
					type: 'flip-x',
					flipX: true
				}]
			}, {
				type: 'item',
				item: 'tickets'
			}];
			default: return null;
		}
	}
}
