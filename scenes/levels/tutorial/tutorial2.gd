extends Level

@onready var _player: Player = $Player
@onready var _goal_qubit: Qubit = $Objects/Circuit/GoalQubit
@onready var _input_qubit: Qubit = $Objects/Circuit/InputQubit
@onready var _quantum_gate_slot: QuantumGateSlot = $Objects/Circuit/InputQubit/QuantumGateSlot
@onready var _door: Door = $Objects/Door


func _ready() -> void:
    LevelRestrictions.reset()
    LevelRestrictions.size_limit = 1
    SignalBus.restrictions_updated.emit()
    SignalBus.hide_hotbar.emit()
    await get_tree().create_timer(LEVEL_DELAY).timeout

    await display("You have just observed the effects of a Pauli-X gate, but there are two more Pauli gates:")
    await display("the Pauli-Y gate, and the Pauli-Z gate.")
    await display("Apply a Pauli-Y gate to the qubit.", true)

    _input_qubit.show()

    LevelRestrictions.allow_gate(QuantumGate.Type.PAULI_Y)
    SignalBus.restrictions_updated.emit()
    SignalBus.show_hotbar.emit()

    _quantum_gate_slot.visible = true
    _quantum_gate_slot.active = true

    while not _input_qubit.next_slot.quantum_gate:
        await SignalBus.circuit_changed

    _quantum_gate_slot.active = false
    LevelRestrictions.reset()
    SignalBus.restrictions_updated.emit()

    await display("That's weird, it looks like it's just the same as the Pauli-X gate!")
    await display("Now apply a Pauli-Z gate.", true)

    _quantum_gate_slot.clear()
    LevelRestrictions.allow_gate(QuantumGate.Type.PAULI_Z)
    SignalBus.restrictions_updated.emit()
    _quantum_gate_slot.active = true

    while not _input_qubit.next_slot.quantum_gate:
        await SignalBus.circuit_changed

    _quantum_gate_slot.active = false
    LevelRestrictions.reset()
    SignalBus.restrictions_updated.emit()

    await display("Even stranger, it looks like this gate is doing nothing at all!")

    _quantum_gate_slot.clear()

    await display("For these gates to be useful, we will need another gate: the Hadamard gate.")
    await display("Apply the Hadamard gate and see what it does.", true)

    LevelRestrictions.allow_gate(QuantumGate.Type.HADAMARD)
    SignalBus.restrictions_updated.emit()
    _quantum_gate_slot.active = true

    while not _input_qubit.next_slot.quantum_gate:
        await SignalBus.circuit_changed

    _quantum_gate_slot.active = false

    await display("Observe how the Hadamard gate puts the state of the qubit in between the poles.")
    await display("This is called superposition.")
    await display("Now apply the Pauli-Z gate again.", true)

    LevelRestrictions.reset()
    LevelRestrictions.allow_gate(QuantumGate.Type.PAULI_Z)
    LevelRestrictions.size_limit = 2
    SignalBus.restrictions_updated.emit()

    _quantum_gate_slot.set_gate(QuantumGate.Type.HADAMARD)

    while not _quantum_gate_slot.next_slot.quantum_gate:
        await SignalBus.circuit_changed

    await display("It actually did something this time!")
    await display("In superposition states, our gates will do completely different things.")

    _quantum_gate_slot.clear()
    LevelRestrictions.reset()
    SignalBus.restrictions_updated.emit()

    _goal_qubit.visible = true
    await display("Now once again match the state of the golden Bloch sphere. This time you can only use Hadamard and Pauli-Z gates, and a maximum of 3 gates in total.", true)

    LevelRestrictions.allow_gate(QuantumGate.Type.PAULI_Z)
    LevelRestrictions.allow_gate(QuantumGate.Type.HADAMARD)
    LevelRestrictions.size_limit = 3
    SignalBus.restrictions_updated.emit()

    _quantum_gate_slot.active = true

    while not _input_qubit.evaluate().equals(_goal_qubit):
        await SignalBus.circuit_changed

    _door.open()

    await display("This conludes the second tutorial!")
    await display("Continue through the door that opened just now.")
    await display("Good luck!")
