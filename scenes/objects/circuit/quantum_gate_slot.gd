## Represents a slot within the quantum circuit, containing a quantum gate.
class_name QuantumCircuitSlot extends Interactable

## Resource path for creating instances of the scene.
const SCENE: PackedScene = preload("res://scenes/objects/circuit/quantum_gate_slot.tscn")

## The input qubit for this circuit slot.
@export var qubit_in: Qubit
## The quantum gate of this circuit slot.
@export var quantum_gate: QuantumGate
## The output qubit of this circuit slot.
@export var qubit_out: Qubit
## The next slot of the circuit.
@export var next_slot: QuantumCircuitSlot

@onready var base = $Base


## Instantiates a Qubit at the specified position.
static func create_qubit(position: Vector3, is_input: bool) -> Qubit:
	var qubit = Qubit.SCENE.instantiate()
	qubit.position = position
	if not is_input:
		qubit.position += (2 * Vector3.RIGHT)
	qubit.active = is_input
	return qubit


## Instantiates a QuantumCircuitSlot at the specified position.
static func create_slot(position: Vector3, qubit: Qubit) -> QuantumCircuitSlot:
	var slot = QuantumCircuitSlot.SCENE.instantiate()
	slot.position = position + (2 * Vector3.RIGHT)
	slot.active = true
	slot.qubit_in = qubit
	slot.quantum_gate = null
	slot.next_slot = null
	qubit.slot = slot
	return slot


func _ready() -> void:
	interaction_text = "
Press [F] to clear
Press [1] to place Identity gate
Press [2] to place Hadamard gate
Press [3] to place Pauli-Y gate
Press [4] to place Pauli-X gate
Press [5] to place Pauli-Z gate
Press [6] to place π/8 gate
"


## Sets the quantum gate of this slot.
func set_gate(gate_scene: PackedScene) -> void:
	# Create the quantum gate
	if quantum_gate != null:
		remove_child(quantum_gate)
	quantum_gate = gate_scene.instantiate()
	add_child(quantum_gate)
	base.visible = false
	
	# Create output qubit for gate
	if qubit_out == null:
		qubit_out = create_qubit(base.position, false)
		add_child(qubit_out)
	
	# Add new empty slot
	if next_slot == null:
		next_slot = create_slot(qubit_out.position, qubit_out)
		add_child(next_slot)
	
	# Update circuit
	qubit_in.propagate()


## Clears the quantum gate slot and all following slots.
func clear() -> void:
	remove_child(quantum_gate)
	remove_child(qubit_out)
	remove_child(next_slot)
	quantum_gate = null
	qubit_out = null
	next_slot = null
	base.visible = true


## Propagates the input qubit through the circuit.
func propagate() -> void:
	if quantum_gate != null and qubit_out != null:
		quantum_gate.propagate(qubit_in, qubit_out)


## Handles interaction by clearing or changing the quantum gate of this slot.
func interact(key: String) -> void:
	if key == "F":
		clear()
	if key == "1":
		set_gate(IdentityGate.SCENE)
	if key == "2":
		set_gate(HadamardGate.SCENE)
	if key == "3": 
		set_gate(PauliYGate.SCENE)
	if key == "4":
		set_gate(PauliXGate.SCENE)
	if key == "5":
		set_gate(PauliZGate.SCENE)
	if key == "6":
		set_gate(Paulipi8Gate.SCENE)
	
