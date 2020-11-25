package data;

import haxe.Constraints.Function;

typedef NPCData = {
    var graphic:String;
    var follow:Bool;
    var flipX:Bool;
    var qualify:Function;
    var canTalk:Function;
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
                flipX: false,
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
                flipX: false,
                follow: false,
                qualify: () -> true,
                canTalk: () -> true,
                bubble: {
                    qualify: () -> !GlobalState.instance.items.contains('pills'),
                    dir: 'right',
                    world: 'joy-thought',
                    background: AssetPaths.thought_background_purple__png
                }
            };
            case 'chris': return {
                graphic: AssetPaths.chris__png,
                flipX: false,
                follow: true,
                qualify: () -> true,
                canTalk: () -> true
            };
            case 'old-woman': return {
                graphic: AssetPaths.old_woman__png,
                flipX: true,
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
                flipX: false,
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
                flipX: true,
                follow: false,
                canTalk: () -> true,
                qualify: () -> true
            };
            default: return null;
        }
    }
}
