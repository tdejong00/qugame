## Represents the user interface (UI) layer.
class_name UI extends CanvasLayer

@export var notification_duration: float = 3.0

@onready var notification_label: Label = $Control/MarginContainer/VBoxContainer/NotificationContainer/NotificationLabel
@onready var interaction_label: Label = $Control/MarginContainer/VBoxContainer/InteractionContainer/InteractionLabel
@onready var identity_button: Button = $Control/MarginContainer/VBoxContainer/ButtonsContainer/IdentityButton
@onready var hadamard_button: Button = $Control/MarginContainer/VBoxContainer/ButtonsContainer/HadamardButton
@onready var pauli_x_button: Button = $Control/MarginContainer/VBoxContainer/ButtonsContainer/PauliXButton
@onready var pauli_y_button: Button = $Control/MarginContainer/VBoxContainer/ButtonsContainer/PauliYButton
@onready var pauli_z_button: Button = $Control/MarginContainer/VBoxContainer/ButtonsContainer/PauliZButton
@onready var pi_over_eight_button: Button = $Control/MarginContainer/VBoxContainer/ButtonsContainer/PiOverEightButton
@onready var timer: Timer = $Timer


func _ready() -> void:
    notification_label.text = ""


func _on_timer_timeout() -> void:
    notification_label.text = ""


## Displays the specified message for a limited duration.
func notify(message: String) -> void:
    notification_label.text = message
    timer.start(notification_duration)
