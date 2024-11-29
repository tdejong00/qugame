## Represents the user interface (UI) layer.
class_name UI extends CanvasLayer

@export var notification_duration: float = 3.0

@onready var notification_label: Label = $Control/MarginContainer/VBoxContainer/NotificationContainer/NotificationLabel
@onready var interaction_label: Label = $Control/MarginContainer/VBoxContainer/InteractionContainer/InteractionLabel
@onready var buttons_container: HBoxContainer = $Control/MarginContainer/VBoxContainer/ButtonsContainer
@onready var timer: Timer = $Timer

var buttons: Array[Button]

var _player: Player

func _ready() -> void:
    _player = get_tree().get_first_node_in_group("player")

    notification_label.text = ""
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
        buttons.append(button)
        buttons_container.add_child(button)


func disable_button(i: int) -> void:
    buttons[i].disabled = true


func _on_timer_timeout() -> void:
    notification_label.text = ""


## Displays the specified message for a limited duration.
func notify(message: String) -> void:
    notification_label.text = message
    timer.start(notification_duration)
