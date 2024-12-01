extends Level

@onready var _goal_qubit: Qubit = $Objects/Circuit/GoalQubit
@onready var _input_qubit: Qubit = $Objects/Circuit/InputQubit
@onready var _quantum_gate_slot: QuantumGateSlot = $Objects/Circuit/InputQubit/QuantumGateSlot

func _ready() -> void:
    SignalBus.hide_hotbar.emit()
    await get_tree().create_timer(LEVEL_DELAY).timeout
    SignalBus.show_hotbar.emit()
    LevelRestrictions.reset()

    await display("Welcome to your first puzzle!")
    await display("Now that you've learned about qubits and the Identity gate, let's introduce two important gates: Pauli-X and Hadamard.")
    await display("First up, the Pauli-X gate. Let's try it out!")

    # Wait for player to apply X gate
    _quantum_gate_slot.active = true
    LevelRestrictions.allow_gate(QuantumGate.Type.PAULI_X)
    SignalBus.restrictions_updated.emit()
    await SignalBus.circuit_changed
    _quantum_gate_slot.active = false

    await display("Great! You’ve flipped the qubit's state.")
    await display("Now let's explore a more powerful gate: the Hadamard gate.")
    await display("The Hadamard gate puts the gate into a state of superposition.")
    await display("Give it a try!")

    # Wait for player to apply H gate
    _quantum_gate_slot.active = true
    LevelRestrictions.allow_gate(QuantumGate.Type.HADAMARD)
    SignalBus.restrictions_updated.emit()
    var expected = Qubit.from_basis_state(Qubit.BasisState.PLUS_REAL)
    while not _input_qubit.evaluate().equals(expected):
        await SignalBus.circuit_changed
    _quantum_gate_slot.active = false

    await display("Great success!")
