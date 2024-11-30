extends Node3D

var _step: int = 0

@onready var input_qubit: Qubit = $Objects/QuantumCircuit/InputQubit


func _ready() -> void:
    SignalBus.hide_hotbar.emit()
    SignalBus.display_dialogue.emit("Welcome to the world of quantum computing!")
    SignalBus.dialogue_finished.connect(_on_dialogue_finished)
    SignalBus.advance_level.connect(_on_advance_level)


func _on_dialogue_finished():
    await get_tree().create_timer(UserInterface.DIALOGUE_DELAY).timeout
    if _step == 0:
        _on_advance_level()


func _on_advance_level():
    _step += 1

    match _step:
        1:
            input_qubit.active = true
            input_qubit.advances_level = true
            SignalBus.display_dialogue.emit("Please toggle the qubit in front of you.")
        2:
            input_qubit.active = false
            input_qubit.advances_level = false
            SignalBus.display_dialogue.emit("Good job! Amazing!")
            
