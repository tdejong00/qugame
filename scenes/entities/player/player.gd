## A 3D physics body representing the player. 
## The player can walk, jump, sprint, and look around. 
class_name Player extends CharacterBody3D

@export_group("Movement")
## Speed at which the player moves while walking.
@export var walk_velocity: float = 4.0
## Speed at which the player moves while sprinting.
@export var sprint_velocity: float = 6.0
## Upward velocity imparted to the player when jumping.
@export var jump_velocity: float = 4.0
## Gravity force applied to the player. This affects how quickly the player
## falls when not on the ground.
@export var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export_group("Camera")
## Sensitivity of the camera to mouse movement.
@export var camera_sensitivity: float = 1.2
## Whether the camera bobbing effect is enabled.
@export var enable_bobbing: bool = true
## Frequency at which the camera bobbing effect occurs while the player is moving.
@export var bob_frequency: float = 2.0
## Amplitude of the camera bobbing effect, which determines how 
## much the camera moves up and down while the player is walking.
@export var bob_amplitude: float = 0.04

## Current interactable object.
var interactable: Interactable

var _bob_t: float = 0.0

@onready var _head: Marker3D = $Marker3D
@onready var _camera: Camera3D = $Marker3D/Camera3D
@onready var _ray_cast: RayCast3D = $Marker3D/Camera3D/RayCast3D


func _ready() -> void:
    SignalBus.interactable_area_entered.connect(_on_interactable_area_entered)
    SignalBus.interactable_area_exited.connect(_on_interactable_area_exited)

    # Stop ray cast from hitting player
    _ray_cast.add_exception(self)

    # Capture mouse
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
    # Handle gravity
    if not is_on_floor():
        velocity.y -= gravity * delta

    # Handle Jump
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = jump_velocity

    # Handle sprint
    var speed = walk_velocity
    if Input.is_action_pressed("sprint"):
        speed = sprint_velocity

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
    if enable_bobbing and is_on_floor():
        _bob_t += velocity.length() * delta
        _bob_camera(_bob_t)

    move_and_slide()


func _input(event) -> void:
    if event is InputEventKey:
        # Handle interactions
        if Input.is_action_just_pressed("interact") and interactable != null:
            interactable.interact(event.as_text_key_label())

        # Skip dialog when an "accept" button is pressed, except "space".
        if Input.is_action_just_pressed("ui_accept") and not Input.is_action_just_pressed("jump"):
            SignalBus.dialogue_skipped.emit()

        # Quit game
        if Input.is_action_just_pressed("quit"):
            get_tree().quit()

    # Handle camera movement
    if event is InputEventMouseMotion:
        _rotate_camera(event)


## Rotates the camera using the relative position of the mouse.
func _rotate_camera(event: InputEventMouseMotion) -> void:
    rotation.y -= event.relative.x * 0.001 * camera_sensitivity
    _camera.rotation.x -= event.relative.y * 0.001 * camera_sensitivity
    _camera.rotation.x = clamp(_camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))


## Applies a bobbing effect to the camera to simulate head movement while walking.
## FIXME: use animation instead
func _bob_camera(t: float) -> void:
    var v = Vector3.ZERO
    v.y = sin(t * bob_frequency) * bob_amplitude
    v.x = cos(t * bob_frequency / 2) * bob_amplitude
    _camera.transform.origin = v


func _on_interactable_area_entered(interactable: Interactable) -> void:
    self.interactable = interactable
    SignalBus.change_interaction_label.emit(interactable.interaction_text)


func _on_interactable_area_exited(interactable: Interactable) -> void:
    if self.interactable == interactable:
        SignalBus.change_interaction_label.emit("")
        self.interactable = null
