## Represents a slot within the quantum circuit, containing a quantum gate.
class_name QuantumGateSlot extends Interactable

## Resource path for creating instances of the scene.
const SCENE: PackedScene = preload("res://scenes/objects/quantum_gate_slot/quantum_gate_slot.tscn")

## The input qubit for this circuit slot.
@export var qubit_in: Qubit
## The quantum gate of this circuit slot.
@export var quantum_gate: QuantumGate
## The output qubit of this circuit slot.
@export var qubit_out: Qubit
## The next slot of the circuit.
@export var next_slot: QuantumGateSlot

@onready var _mesh_instance = $MeshInstance3D


func _ready() -> void:
    interaction_text = "Press [F] to clear"


## Instantiates a Qubit at the specified position.
static func create_qubit(position: Vector3, is_input: bool) -> Qubit:
    var qubit = Qubit.SCENE.instantiate()
    qubit.position = position
    if not is_input:
        qubit.position += (2 * Vector3.RIGHT)
    return qubit


## Instantiates a QuantumCircuitSlot at the specified position.
static func create_slot(position: Vector3, qubit: Qubit) -> QuantumGateSlot:
    var slot = QuantumGateSlot.SCENE.instantiate()
    slot.position = position + (2 * Vector3.RIGHT)
    slot.active = true
    slot.qubit_in = qubit
    slot.quantum_gate = null
    slot.next_slot = null
    qubit.next_slot = slot
    return slot


## Sets the quantum gate of this slot.
func set_gate(type: QuantumGate.Type) -> void:
    # Create the quantum gate
    if quantum_gate != null:
        remove_child(quantum_gate)
    quantum_gate = QuantumGate.SCENE.instantiate()
    quantum_gate.type = type
    add_child(quantum_gate)
    _mesh_instance.visible = false

    # Create output qubit for gate
    if qubit_out == null:
        qubit_out = create_qubit(_mesh_instance.position, false)
        add_child(qubit_out)

    # Add new empty slot
    if can_add_empty_slot():
        next_slot = create_slot(qubit_out.position, qubit_out)
        add_child(next_slot)

    # Update circuit
    qubit_in.propagate()


## Determines whether an empty slot can be added based on the size restriction.
func can_add_empty_slot():
    var slots = get_tree().get_nodes_in_group("circuit")
    return next_slot == null and LevelRestrictions.is_size_allowed(slots.size())


## Clears the quantum gate slot and all following slots.
func clear() -> void:
    remove_child(quantum_gate)
    remove_child(qubit_out)
    remove_child(next_slot)
    quantum_gate = null
    qubit_out = null
    next_slot = null
    _mesh_instance.visible = true


## Propagates the input qubit through the circuit.
func propagate() -> void:
    if quantum_gate != null and qubit_out != null:
        quantum_gate.propagate(qubit_in, qubit_out)
    else:
        SignalBus.circuit_changed.emit()


## Evaluates the circuit to a single qubit.
func evaluate() -> Qubit:
    if qubit_out != null:
        return qubit_out.evaluate()
    else:
        return qubit_in

## Handles interaction by clearing or changing the quantum gate of this slot.
func interact(key: String) -> void:
    super.interact(key)
    if key == "F":
        clear()
    elif key.is_valid_int():
        # Implicitly convert number input to gate type enum
        var type: QuantumGate.Type = key.to_int() - 1
        if LevelRestrictions.is_gate_allowed(type):
            set_gate(type)
