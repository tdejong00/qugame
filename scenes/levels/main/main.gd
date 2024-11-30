extends Node3D

@onready var goal_qubit: Qubit = $Objects/QuantumCircuit/GoalQubit
@onready var input_qubit: Qubit = $Objects/QuantumCircuit/InputQubit
@onready var door: Door = $Objects/Door


func _ready() -> void:
    LevelRestrictions.allowe_gate(QuantumGate.Type.HADAMARD)
    SignalBus.restrictions_updated.emit()

    SignalBus.circuit_changed.connect(_on_circuit_changed)
    _on_circuit_changed()


func _on_circuit_changed() -> void:
    if not door.is_open and input_qubit.propagate().equals(goal_qubit):
        door.open()
    else:
        door.close()
