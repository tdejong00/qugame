extends Level

@onready var _player: Player = $Player
@onready var _goal_qubit: Qubit = $Objects/Circuit/GoalQubit
@onready var _input_qubit: Qubit = $Objects/Circuit/InputQubit
@onready var _quantum_gate_slot: QuantumGateSlot = $Objects/Circuit/InputQubit/QuantumGateSlot
@onready var _door: Door = $Objects/Door


func _ready() -> void:
    LevelRestrictions.size_limit = 1
    SignalBus.restrictions_updated.emit()
    SignalBus.hide_hotbar.emit()
    await get_tree().create_timer(LEVEL_DELAY).timeout

    await display("Welcome, to the world of quantum computing!")
    await display("Before we start, let’s learn the basics of how quantum bits, or qubits, work.")
    await display("In the classical world, we use bits: things that can be either 0 (off) or 1 (on).")

    _input_qubit.show()
    await display("Just like a classical bit, a qubit can be in state 0 (up)...")
    _input_qubit.set_state(Qubit.BasisState.ONE)
    await display("...or in state 1 (down).")
    _input_qubit.set_state(Qubit.BasisState.ZERO)
    await display("This visualization of a qubit's state is called a Bloch sphere.")
    await display("Here's where qubits get interesting; they can be in superposition!")
    _input_qubit.set_state(Qubit.BasisState.PLUS_REAL)
    await display("In superposition, the qubit is \"in both states at the same time\" until we measure it.")
    _input_qubit.set_state(Qubit.BasisState.ZERO)
    await display("Now that we understand the basic qubit states, let's see how we can manipulate these states using quantum gates.")
    await display("Just like classical computers use logic gates, quantum computers use quantum gates to change qubits.")
    LevelRestrictions.allow_gate(QuantumGate.Type.IDENTITY)
    SignalBus.restrictions_updated.emit()
    SignalBus.show_hotbar.emit()
    await display("Let’s start with the simplest gate: the Identity gate.")
    await display("The Identity gate does... nothing!")
    await display("Apply the Identity gate to the input qubit.", true)

    # Wait for player to apply I gate
    _quantum_gate_slot.visible = true
    _quantum_gate_slot.active = true
    while not _input_qubit.next_slot.quantum_gate:
        await SignalBus.circuit_changed
    _quantum_gate_slot.active = false

    await display("Great! The Identity gate leaves the qubit in its current state.")
    await display("Let's move on to a more useful gate: the Pauli-X gate.")
    await display("Apply the Pauli-X gate to the input qubit.", true)

    # Wait for player to apply X gate
    LevelRestrictions.allow_gate(QuantumGate.Type.PAULI_X)
    SignalBus.restrictions_updated.emit()
    var expected = Qubit.from_basis_state(Qubit.BasisState.ONE)
    _quantum_gate_slot.active = true
    while not _input_qubit.evaluate().equals(expected):
        await SignalBus.circuit_changed
    _quantum_gate_slot.active = false

    await display("Great! You’ve flipped the qubit's state.")
    _goal_qubit.visible = true
    await display("Take a look at the bigger, golden Bloch sphere.")
    await display("Match the state of the golden Bloch sphere.", true)

    # Wait for player to match state
    LevelRestrictions.size_limit = 2
    SignalBus.restrictions_updated.emit()
    _quantum_gate_slot.set_gate(_quantum_gate_slot.quantum_gate.type)
    while not _input_qubit.evaluate().equals(_goal_qubit):
        await SignalBus.circuit_changed

    _quantum_gate_slot.next_slot.active = false
    _door.open()

    await display("This conludes the first tutorial!")
    await display("Continue through the door that opened just now.")
    await display("Good luck!")
