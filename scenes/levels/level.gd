## Represents a level of the game.
class_name Level extends Node3D


## Convenience function for displaying a dialogue and awaiting its completion.
func display(message: String) -> void:
    SignalBus.display_dialogue.emit(message)
    await SignalBus.dialogue_finished
