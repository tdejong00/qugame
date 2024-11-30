## Represents the user interface (UI) layer.
class_name UserInterface extends CanvasLayer

## The delay between typing characters of the dialogue.
const TYPING_DELAY: float = 0.04

## The delay after the dialogue has finished.
const DIALOGUE_DELAY: float = 2.0

var _is_displaying_dialogue: bool = false
var _stop_displaying_dialogue: bool = false

@onready var _interaction_label: Label = $Control/MarginContainer/VBoxContainer/InteractionContainer/InteractionLabel
@onready var _buttons_container: HBoxContainer = $Control/MarginContainer/VBoxContainer/ButtonsContainer
@onready var _dialogue_label: Label = $Control/MarginContainer/VBoxContainer/DialogueContainer/DialogueLabel
@onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
    SignalBus.show_hotbar.connect(_on_show_hotbar)
    SignalBus.hide_hotbar.connect(_on_hide_hotbar)
    SignalBus.display_dialogue.connect(_on_display_dialogue)
    SignalBus.interaction_label_changed.connect(_on_interaction_label_changed)
    SignalBus.restrictions_updated.connect(_on_restrictions_updated)
    SignalBus.fade_out.connect(_on_fade_out)

    ## Add hotbar slot for every gate type
    for type in QuantumGate.Type.values():
        _add_hotbar_slot(type)


## Adds a slot to the hotbar for the specified gate type.
## All slots are disable by default.
func _add_hotbar_slot(type: QuantumGate.Type) -> void:
    # Create "button"
    var button: Button = Button.new()
    button.custom_minimum_size = Vector2(72, 72)
    button.add_theme_font_size_override("font_size", 28)
    button.disabled = true
    button.text = "?"

    # Create index label
    var label: Label = Label.new()
    label.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
    label.position += Vector2(6, 2)
    label.add_theme_font_size_override("font_size", 14)
    label.text = str(type + 1)

    # Add to scene
    button.add_child(label)
    _buttons_container.add_child(button)


## Shows the hotbar.
func _on_show_hotbar() -> void:
    _buttons_container.visible = true


## Hides the hotbar.
func _on_hide_hotbar() -> void:
    _buttons_container.visible = false


## Changes whether the slot corresponding to the specified type should
## be enabled or disabled.
func _on_restrictions_updated() -> void:
    for type in QuantumGate.Type.values():
        var button: Button = _buttons_container.get_child(type)
        button.disabled = not LevelRestrictions.is_gate_allowed(type)
        button.text = "?" if button.disabled else QuantumGate.type_to_string(type)


## Writes the specified dialogue character by character.
## If a dialogue is already being written, it is stopped
## prematurely.
func _on_display_dialogue(text: String) -> void:
    _stop_displaying_dialogue = _is_displaying_dialogue

    # Wait for displaying dialogue to stop
    while _is_displaying_dialogue:
        await get_tree().create_timer(TYPING_DELAY).timeout

    _is_displaying_dialogue = true

    _dialogue_label.text = ""
    for i in range(text.length()):
        # Stop the dialogue when a new dialogue is issued
        if _stop_displaying_dialogue:
            _stop_displaying_dialogue = false
            _is_displaying_dialogue = false
            return

        # Add next character of dialogue
        _dialogue_label.text += text[i]
        await get_tree().create_timer(TYPING_DELAY).timeout

    _is_displaying_dialogue = false
    _stop_displaying_dialogue = false

    await get_tree().create_timer(DIALOGUE_DELAY).timeout
    # FIXME: it is possible that the dialogue gets cleared
    #        too early, when this message was ended prematurely
    #        and the next message ended before this timer ran out.
    if not _is_displaying_dialogue:
        _dialogue_label.text = ""
        SignalBus.dialogue_finished.emit()


## Displays the specified interaction text.
func _on_interaction_label_changed(text: String) -> void:
    _interaction_label.text = text


## Transitions to the specified scene by fade out.
func _on_fade_out(packed_scene: PackedScene) -> void:
    _animation_player.play("fade_out")
    await _animation_player.animation_finished
    get_tree().change_scene_to_packed(packed_scene)
