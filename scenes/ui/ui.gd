## Represents the user interface (UI) layer.
class_name UI extends CanvasLayer

@onready var interaction_label: Label = $Control/MarginContainer/VBoxContainer/HBoxContainer/InteractionLabel
@onready var identity_button: Button = $Control/MarginContainer/VBoxContainer/Buttons/IdentityButton
@onready var hadamard_button: Button = $Control/MarginContainer/VBoxContainer/Buttons/HadamardButton
@onready var pauli_x_button: Button = $Control/MarginContainer/VBoxContainer/Buttons/PauliXButton
@onready var pauli_y_button: Button = $Control/MarginContainer/VBoxContainer/Buttons/PauliYButton
@onready var pauli_z_button: Button = $Control/MarginContainer/VBoxContainer/Buttons/PauliZButton
@onready var pi_over_eight_button: Button = $Control/MarginContainer/VBoxContainer/Buttons/PiOverEightButton
