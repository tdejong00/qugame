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

## The amplitude for the |0⟩ state.
var _alpha: Vector2
## The amplitude for the |1⟩ state.
var _beta: Vector2
## The polar angle that determines the qubit's position on the Bloch sphere.
var _theta: float
## The azimuthal angle that represents the relative phase between α and β.
var _phi: float

@onready var bloch_sphere: Node3D = $BlochSphere
@onready var bloch_sphere_arrow: Node3D = $BlochSphere/Arrow
@onready var area: Area3D = $Base/Area3D

## Returns a string representation of the qubit state in Dirac notation.
func _to_string() -> String:
    return "|Ψ⟩ = " + str(_alpha) + "|0⟩ " + str(_beta) + "|1⟩"


func _ready() -> void:
    bloch_sphere.visible = false


func _physics_process(delta: float) -> void:
    # Rotate towards target rotation
    if bloch_sphere_arrow.rotation.z != -_theta:
        bloch_sphere_arrow.rotation.z = lerp_angle(bloch_sphere_arrow.rotation.z,-_theta, ROTATION_SPEED * delta)
    if bloch_sphere_arrow.rotation.y != _phi:
        bloch_sphere_arrow.rotation.y = lerp_angle(bloch_sphere_arrow.rotation.y, _phi, ROTATION_SPEED * delta)


func _on_area_3d_body_entered(body: Node3D) -> void:
    if body is Player:
        body.interactable = self
    

func _on_area_3d_body_exited(body: Node3D) -> void:
    if body is Player:
        body.interactable = null


## TODO
func interact() -> void:
    bloch_sphere.visible = !bloch_sphere.visible


## Creates an instance of the scene and initializes it with the specified amplitudes.
static func create(alpha: Vector2, beta: Vector2) -> Qubit:
    var instance: Qubit = SCENE.instantiate()
    instance._alpha = alpha
    instance._beta = beta
    instance.normalize()
    
    # Set theta angle
    var alpha_norm = sqrt(instance.alpha.x ** 2 + instance.alpha.y ** 2)
    instance.theta = 2 * acos(alpha_norm)
    
    # Set phi angle
    var alpha_phase = atan2(instance.alpha.y, instance.alpha.x)
    var beta_phase = atan2(instance.beta.y, instance.beta.x)
    instance.phi = beta_phase - alpha_phase
    
    # Ensure phi is within range [0, 2π]
    if instance.phi < 0:
        instance.phi += PI * 2
    
    return instance


## Normalizes the qubit state to ensure |α|² + |β|² = 1.
func normalize() -> void:
    var norm = sqrt((_alpha.x ** 2 + _alpha.y ** 2) + (_beta.x ** 2 + _beta.y ** 2))
    _alpha /= norm
    _beta /= norm
