## Represents a level of the game.
class_name Level extends Node3D

## The delay before the level starts.
const LEVEL_DELAY: float = 2.0


## Convenience function for displaying a dialogue and awaiting its completion.
func display(message: String) -> void:
    SignalBus.display_dialogue.emit(message)
    await SignalBus.dialogue_finished
