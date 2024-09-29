## A 3D physics body representing the player. 
## The player can walk, jump, sprint, and look around. 
class_name Player extends CharacterBody3D

@export_group("Movement")
## Speed at which the player moves while walking.
@export var walk_velocity: float = 3.0
## Speed at which the player moves while sprinting.
@export var sprint_velocity: float = 5.0
## Upward velocity imparted to the player when jumping.
@export var jump_velocity: float = 4.0
## Gravity force applied to the player. This affects how quickly the player
## falls when not on the ground.
@export var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export_group("Camera")
## Sensitivity of the camera to mouse movement.
@export var camera_sensitivity: float = 1.0
## Frequency at which the camera bobbing effect occurs while the player is moving.
@export var bob_frequency: float = 2.0
## Amplitude of the camera bobbing effect, which determines how 
## much the camera moves up and down while the player is walking.
@export var bob_amplitude: float = 0.04

var _bob_t: float = 0.0

@onready var player: CharacterBody3D = $"."
@onready var head: Marker3D = $Marker3D
@onready var camera: Camera3D = $Marker3D/Camera3D


func _ready():
    # Capture mouse
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float):
    # Handle _gravity
    if not is_on_floor():
        velocity.y -= gravity * delta
    
    # Handle Jump
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = jump_velocity
        
    # Handle sprint
    var speed = walk_velocity
    if Input.is_action_pressed("sprint"):
        speed = sprint_velocity

    # Quit game
    if Input.is_action_just_pressed("quit"):
        get_tree().quit()

    # Get input direction and handle movement/deceleration.
    var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    if is_on_floor():
        if direction:
            velocity.x = direction.x * speed
            velocity.z = direction.z * speed
        else:
            velocity.x = 0.0
            velocity.z = 0.0
    else:
        velocity.x = lerp(velocity.x, direction.x * speed, delta)
        velocity.z = lerp(velocity.z, direction.z * speed, delta)

    # Handle view bobbing
    if is_on_floor():
        _bob_t += velocity.length() * delta
        bob_camera(_bob_t)

    move_and_slide()


func _input(event):
    # Handle camera movement
    if event is InputEventMouseMotion:
        rotate_camera(event)


## Rotates the camera using the relative position of the mouse.
func rotate_camera(event: InputEventMouseMotion):
    player.rotation.y -= event.relative.x * 0.001 * camera_sensitivity
    camera.rotation.x -= event.relative.y * 0.001 * camera_sensitivity
    camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))


## Applies a bobbing effect to the camera to simulate head movement while walking.
func bob_camera(t: float):
    var v = Vector3.ZERO
    v.y = sin(t * bob_frequency) * bob_amplitude
    v.x = cos(t * bob_frequency / 2) * bob_amplitude
    camera.transform.origin = v
