class_name BlochSphere extends Node3D

@onready var arrow: Node3D = $Arrow

const ROTATION_SPEED: float = 5.0

@export_range(0.0, PI) var theta: float = 0.0
@export_range(0.0, TAU) var phi: float = 0.0
    
func _ready():
    arrow.rotation.z = -theta
    arrow.rotation.y = phi
    
func _physics_process(delta: float):
    if Input.is_action_just_pressed("use"):
        theta = randf_range(0.0, PI)
        phi = randf_range(0.0, TAU)
    
    if arrow.rotation.z != -theta:
        arrow.rotation.z = lerp_angle(arrow.rotation.z, -theta, ROTATION_SPEED * delta)
    if arrow.rotation.y != phi:
        arrow.rotation.y = lerp_angle(arrow.rotation.y, phi, ROTATION_SPEED * delta)
