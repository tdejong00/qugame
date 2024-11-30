## Global file containing various signals, which can be emitted and connected
## to. We make a distinction between events that HAVE happened and that SHOULD
## happen. This is reflected in the tense of the verb.
extends Node

## Emitted when the level restrictions have been updated.
signal restrictions_updated

## Emitted when the hotbar should be hidden.
signal hide_hotbar
## Emitted when the hotbar should be shown.
signal show_hotbar

## Emitted when the specified text should be displayed as a dialogue.
signal display_dialogue(text: String)
## Emitted when the dialogue was skipped.
signal dialogue_skipped
## Emitted when the dialouge has finished.
signal dialogue_finished

## Emitted when the interaction label should be changed.
signal change_interaction_label(text: String)

## Emitted when the circuit has changed.
signal circuit_changed

## Emitted when the scene should transition to the next scene using a fade out.
signal fade_out(packed_scene: PackedScene)
