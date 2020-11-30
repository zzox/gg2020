package data;

import haxe.Constraints.Function;

typedef NPCData = {
    var graphic:String;
    var follow:Bool;
    var flipX:Function;
    var qualify:Function;
    var canTalk:Function;
    var ?forcedAnim:String;
    var ?bubble:Bubble;
}

typedef Bubble = {
    var dir:String;
    var world:String;
    var background:String;
    var qualify:Function;
}

class NPCs {
    static public function getNPC (name:String):Null<NPCData> {
        switch (name) {
            case 'mom': return {
                graphic: AssetPaths.mom__png,
                follow: true,
                flipX: () -> false,
                qualify: () -> !GlobalState.instance.momIsSleeping,
                canTalk: () -> false,
                bubble: {
                    qualify: () -> true,
                    dir: 'right',
                    world: 'mom-thought',
                    background: AssetPaths.thought_background_pink__png
                }
            };
            case 'joy': return {
                graphic: AssetPaths.joy__png,
                flipX: () -> true,
                follow: false,
                qualify: () -> true,
                canTalk: () -> true,
                bubble: {
                    qualify: () -> {
                        var gs = GlobalState.instance;
                        if (!gs.items.contains('pills') && gs.currentRoom == 'hometown') {
                            return true;
                        }

                        return false;
                    },
                    dir: 'right',
                    world: 'joy-thought',
                    background: AssetPaths.thought_background_purple__png
                }
            };
            case 'chris': return {
                graphic: AssetPaths.chris__png,
                flipX: () -> false,
                follow: true,
                qualify: () -> {
                    var gs = GlobalState.instance;
                    if (gs.currentRoom == 'downtown' && gs.chrisLeftForTickets) {
                        return false;
                    }

                    return true;
                },
                canTalk: () -> true
            };
            case 'old-woman': return {
                graphic: AssetPaths.old_woman__png,
                flipX: () -> {
                    if (GlobalState.instance.currentRoom == 'dock') {
                        return false;
                    }

                    return true;
                },
                follow: false,
                canTalk: () -> true,
                qualify: () -> true,
                bubble: {
                    qualify: () -> GlobalState.instance.currentRoom == 'hometown',
                    dir: 'left',
                    world: 'old-woman-thought',
                    background: AssetPaths.thought_background_orange__png
                }
            };
            case 'busdriver': return {
                graphic: AssetPaths.busdriver__png,
                flipX: () -> false,
                follow: false,
                canTalk: () -> true,
                qualify: () -> true,
                bubble: {
                    qualify: () -> true,
                    dir: 'right',
                    world: 'busdriver-thought',
                    background: AssetPaths.thought_background_pink__png
                }
            };
            case 'bouncer-one': return {
                graphic: AssetPaths.bouncer_one__png,
                flipX: () -> true,
                follow: false,
                canTalk: () -> true,
                qualify: () -> true,
                bubble: {
                    qualify: () -> GlobalState.instance.currentRoom == 'bus',
                    dir: 'left',
                    world: 'bouncer-one-thought',
                    background: AssetPaths.thought_background_orange__png
                }
            };
            case 'bouncer-two': return {
                graphic: AssetPaths.bouncer_two__png,
                flipX: () -> false,
                follow: false,
                canTalk: () -> true,
                qualify: () -> true
            };
            case 'creep-one': return {
                graphic: AssetPaths.creep_one__png,
                flipX: () -> false,
                follow: false,
                canTalk: () -> true,
                qualify: () -> true
            };
            case 'creep-two': return {
                graphic: AssetPaths.creep_two__png,
                flipX: () -> true,
                follow: false,
                canTalk: () -> true,
                qualify: () -> true
            };
            case 'dj-hellgirl': return {
                graphic: AssetPaths.hellgirl__png,
                flipX: () -> false,
                follow: true,
                canTalk: () -> true,
                qualify: () -> true
            };
            case 'dancing-woman': return {
                graphic: AssetPaths.dancing_woman__png,
                flipX: () -> false,
                follow: false,
                canTalk: () -> true,
                forcedAnim: 'dance',
                qualify: () -> !GlobalState.instance.dancingWomanCalledGrandma,
                bubble: {
                    qualify: () -> {
                        if (GlobalState.instance.informedByOldWoman) {
                            return true;
                        }

                        return false;
                    },
                    dir: 'left',
                    world: 'dancing-woman-thought',
                    background: AssetPaths.thought_background_pink__png
                }
            };
            default: return null;
        }
    }
}
