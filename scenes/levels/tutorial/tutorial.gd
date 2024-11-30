extends Level

@onready var _player: Player = $Player
@onready var _goal_qubit: Qubit = $Objects/QuantumCircuit/GoalQubit
@onready var _input_qubit: Qubit = $Objects/QuantumCircuit/InputQubit
@onready var _quantum_gate_slot: QuantumGateSlot = $Objects/QuantumCircuit/InputQubit/QuantumGateSlot
@onready var _door: Door = $Objects/Door


func _ready() -> void:
    SignalBus.hide_hotbar.emit()
    SignalBus.circuit_changed.connect(_on_circuit_changed)
    await get_tree().create_timer(2.0).timeout

    await display("Welcome, to the world of quantum computing!")
    await display("Before we start, let’s learn the basics of how quantum bits—or qubits—work.")
    await display("In the classical world, we use bits: things that can be either 0 (off) or 1 (on).")

    _input_qubit.show()
    _player.look_at(_input_qubit.position)
    await display("Just like a classical bit, a qubit can be in state 0 (up) or in state 1 (down).")
    await display("This visualization of a qubit's state is called a Bloch Sphere.")
    await display("Try flipping the qubit's state!")

    # Wait for player to flip input qubit
    _input_qubit.active = true
    await SignalBus.circuit_changed

    _input_qubit.active = false
    await display("Great! But here's where qubits get interesting; they can be in both states at once!")
    _input_qubit.set_state(Qubit.BasisState.PLUS_REAL)
    await display("We call this superposition.")
    _input_qubit.set_state(Qubit.BasisState.ZERO)
    await display("Now that we know what a qubit is, let’s see how we can manipulate it.")
    await display("Just like classical computers use logic gates, quantum computers use quantum gates to change qubits.")
    LevelRestrictions.allow_gate(QuantumGate.Type.IDENTITY)
    SignalBus.restrictions_updated.emit()
    SignalBus.show_hotbar.emit()
    await display("Let’s start with the simplest gate: the Identity gate.")
    await display("The Identity gate does... nothing! It leaves the qubit in its current state.")

    await display("Try applying it to the input qubit!")

    # Wait for player to apply gate
    _quantum_gate_slot.visible = true
    _quantum_gate_slot.active = true
    while not _input_qubit.next_slot.quantum_gate:
        await SignalBus.circuit_changed

    _goal_qubit.visible = true
    _quantum_gate_slot.active = false
    _input_qubit.active = false
    await display("Great! Now try to match the qubit state displayed by the bigger, golden Bloch sphere.")

    # Wait for player to match state
    _quantum_gate_slot.active = true
    _input_qubit.active = true
    await _door.door_opened

    await display("This conludes the tutorial! Continue through the door that opened just now. Good luck!")


## Evaluates the circuit and opens the door if it matches the goal state.
func _on_circuit_changed() -> void:
    if not _door.is_open and _input_qubit.evaluate().equals(_goal_qubit):
        _door.open()
    else:
        _door.close()
