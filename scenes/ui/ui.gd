## Represents the user interface (UI) layer.
class_name UI extends CanvasLayer

## The delay between typing characters of the dialogue.
const TYPING_DELAY: float = 0.04

## The delay after the dialogue has finished.
const DIALOGUE_DELAY: float = 2.0

@onready var interaction_label: Label = $Control/MarginContainer/VBoxContainer/InteractionContainer/InteractionLabel
@onready var buttons_container: HBoxContainer = $Control/MarginContainer/VBoxContainer/ButtonsContainer
@onready var dialogue_label: Label = $Control/MarginContainer/VBoxContainer/DialogueContainer/DialogueLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _player: Player

var _is_displaying_dialogue: bool = false
var _stop_displaying_dialogue: bool = false


func _ready() -> void:
    SignalBus.display_dialogue.connect(_on_display_dialogue)
    SignalBus.dialogue_finished.connect(_on_dialogue_finished)

    _player = get_tree().get_first_node_in_group("player")

    for type in QuantumGate.Type.values():
        # Create "button"
        var button: Button = Button.new()
        button.custom_minimum_size = Vector2(72, 72)
        button.add_theme_font_size_override("font_size", 28)
        button.disabled = !_player.is_gate_allowed(type)
        button.text = "?" if button.disabled else QuantumGate.type_to_string(type)

        # Create index label
        var label: Label = Label.new()
        label.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
        label.position += Vector2(6, 2)
        label.add_theme_font_size_override("font_size", 14)
        label.text = str(type + 1)

        # Add to scene
        button.add_child(label)
        buttons_container.add_child(button)


func _on_display_dialogue(dialogue: String) -> void:
    _stop_displaying_dialogue = _is_displaying_dialogue

    # Wait for displaying dialogue to stop
    while _is_displaying_dialogue:
        await get_tree().create_timer(0.01).timeout

    _is_displaying_dialogue = true

    dialogue_label.text = ""
    for i in range(dialogue.length()):
        # Stop the dialogue when a new dialogue is issued
        if _stop_displaying_dialogue:
            _stop_displaying_dialogue = false
            _is_displaying_dialogue = false
            return

        # Add next character of dialogue
        dialogue_label.text += dialogue[i]
        await get_tree().create_timer(TYPING_DELAY).timeout

    _is_displaying_dialogue = false
    _stop_displaying_dialogue = false
    SignalBus.dialogue_finished.emit()


func _on_dialogue_finished():
    await get_tree().create_timer(DIALOGUE_DELAY).timeout
    if not _is_displaying_dialogue:
        dialogue_label.text = ""
