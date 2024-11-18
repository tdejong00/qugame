## Represents a quantum bit (qubit) that can exist in a superposition of states.
##
## A qubit is represented using two complex amplitudes, α (alpha) and β (beta), where:
## - α represents the amplitude for the |0⟩ state.
## - β represents the amplitude for the |1⟩ state.
## The state of the qubit is normalized such that |α|² + |β|² = 1.
##
## Additionally, the qubit's state can be described using spherical coordinates:
## - θ (theta): The polar angle that determines the qubit's position on the Bloch sphere.
## - φ (phi): The azimuthal angle that represents the relative phase between α and β.
class_name Qubit extends Interactable

## Resource path for creating instances of the Qubit scene.
const SCENE: PackedScene = preload("res://scenes/objects/qubit/qubit.tscn")

## Speed at which the Bloch sphere arrow rotates towards its target orientation.
const ROTATION_SPEED: float = 5.0

## Whether the bloch shpere is shown by default.
@export var show_bloch_sphere: bool = true
## The quantum circuit slot which this qubit is an input for.
@export var slot: QuantumCircuitSlot

## The amplitude for the |0⟩ state.
var alpha: Vector2 = Vector2.RIGHT
## The amplitude for the |1⟩ state.
var beta: Vector2 = Vector2.ZERO
## The polar angle that determines the qubit's position on the Bloch sphere.
var _theta: float = 0.0
## The azimuthal angle that represents the relative phase between α and β.
var _phi: float = 0.0

@onready var bloch_sphere: Node3D = $BlochSphere
@onready var bloch_sphere_arrow: Node3D = $BlochSphere/Arrow
@onready var bloch_sphere_arrow_head: MeshInstance3D = $BlochSphere/Arrow/ArrowHead
@onready var bloch_sphere_arrow_body: MeshInstance3D = $BlochSphere/Arrow/ArrowBody


func _ready() -> void:
	bloch_sphere.visible = show_bloch_sphere
	propagate()


func _physics_process(delta: float) -> void:
	# Rotate towards target rotation
	if bloch_sphere_arrow.rotation.z != -_theta:
		bloch_sphere_arrow.rotation.z = lerp_angle(bloch_sphere_arrow.rotation.z,-_theta, ROTATION_SPEED * delta)
	if bloch_sphere_arrow.rotation.y != _phi:
		bloch_sphere_arrow.rotation.y = lerp_angle(bloch_sphere_arrow.rotation.y, _phi, ROTATION_SPEED * delta)


## Returns a string representation of the qubit state in Dirac notation.
func _to_string() -> String:
	return "|Ψ⟩ = " + str(alpha) + "|0⟩ " + str(beta) + "|1⟩"


## Determines whether the qubit represents |0⟩.
func is_zero() -> bool:
	return alpha == Vector2.RIGHT && beta == Vector2.ZERO


## Determines whether the qubit represents |1⟩.
func is_one() -> bool:
	return alpha == Vector2.ZERO && beta == Vector2.RIGHT


## Updates the polar angle and relative phase of the qubit
## and propagates the result to the next quantum gate.
func propagate() -> void:
	print(self)
	
	# Set theta angle
	var alpha_norm = sqrt(alpha.x ** 2 + alpha.y ** 2)
	_theta = 2 * acos(alpha_norm)
	
	# Set phi angle
	var alpha_phase = atan2(alpha.y, alpha.x)
	var beta_phase = atan2(beta.y, beta.x)
	_phi = beta_phase - alpha_phase
	
	# Ensure phi is within range [0, 2π]
	if _phi < 0:
		_phi += PI * 2

	if slot != null:
		slot.propagate()


## Toggles between basis states.
func interact(key: String) -> void:
	if key == "F":
		assert(is_zero() || is_one())
		alpha.x = 0 ** alpha.x
		beta.x = 0 ** beta.x
		propagate()
