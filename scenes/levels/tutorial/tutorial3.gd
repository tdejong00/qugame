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

    await display("You might be familiar with an \"universal gate set\" in classical computing.")
    await display("Quantum computing also has a notion of universal gate sets.")
    await display("In our case of single-qubits, with just the Hadamard and T gates we can approximate any operation.")
    await display("The T gate is also called the π/8 gate.")
    await display("Apply it a couple of times and observe what happens", true)

    _input_qubit.show()

    LevelRestrictions.allow_gate(QuantumGate.Type.PI_OVER_8)
    LevelRestrictions.size_limit = 4
    SignalBus.restrictions_updated.emit()
    SignalBus.show_hotbar.emit()

    _quantum_gate_slot.visible = true

    _quantum_gate_slot.set_gate(QuantumGate.Type.HADAMARD)

    while get_tree().get_nodes_in_group("circuit").size() != 4:
        await SignalBus.circuit_changed

    await display("When the T gate is applied to a state in superposition, it performs a small rotation.")
    await display("Use this together with your knowledge of the Hadamard gate to match the state of the golden Bloch sphere.", true)

    _goal_qubit.visible = true

    _quantum_gate_slot.clear()
    LevelRestrictions.reset()
    SignalBus.restrictions_updated.emit()

    LevelRestrictions.allow_gate(QuantumGate.Type.PI_OVER_8)
    LevelRestrictions.allow_gate(QuantumGate.Type.HADAMARD)
    LevelRestrictions.size_limit = 6
    SignalBus.restrictions_updated.emit()

    _quantum_gate_slot.active = true

    while not _input_qubit.evaluate().equals(_goal_qubit):
        await SignalBus.circuit_changed

    _door.open()

    await display("This conludes the third tutorial!")
    await display("Congratulations on completing all tutorials!")
    await display("Continue through the door that opened just now.")
