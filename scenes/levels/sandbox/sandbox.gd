extends Level


func _ready() -> void:
    LevelRestrictions.reset()
    LevelRestrictions.allow_gate(QuantumGate.Type.IDENTITY)
    LevelRestrictions.allow_gate(QuantumGate.Type.HADAMARD)
    LevelRestrictions.allow_gate(QuantumGate.Type.PAULI_X)
    LevelRestrictions.allow_gate(QuantumGate.Type.PAULI_Y)
    LevelRestrictions.allow_gate(QuantumGate.Type.PAULI_Z)
    LevelRestrictions.allow_gate(QuantumGate.Type.PI_OVER_8)
    LevelRestrictions.size_limit = -1
    SignalBus.restrictions_updated.emit()

    await display("Welcome to sandbox mode!")
    await display("In this mode you can use all gate types and as many as you would want.")
