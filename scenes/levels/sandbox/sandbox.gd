extends Level

@onready var _goal_qubit: Qubit = $Objects/Circuit/GoalQubit
@onready var _input_qubit: Qubit = $Objects/Circuit/InputQubit
@onready var _door: Door = $Objects/Door


func _ready() -> void:
    LevelRestrictions.allow_gate(QuantumGate.Type.IDENTITY)
    LevelRestrictions.allow_gate(QuantumGate.Type.HADAMARD)
    LevelRestrictions.allow_gate(QuantumGate.Type.PAULI_X)
    LevelRestrictions.allow_gate(QuantumGate.Type.PAULI_Y)
    LevelRestrictions.allow_gate(QuantumGate.Type.PAULI_Z)
    LevelRestrictions.allow_gate(QuantumGate.Type.PI_OVER_8)
    SignalBus.restrictions_updated.emit()