## Represents a quantum gate that can apply transformations to a qubit using a defined matrix.
class_name QuantumGate extends Node3D

## The possible quantum gate types.
enum Type {
    IDENTITY,
    HADAMARD,
    PAULI_X,
    PAULI_Y,
    PAULI_Z,
    PI_OVER_8
}

## Resource path for creating instances of the scene.
const SCENE: PackedScene = preload("res://scenes/objects/quantum_gate/quantum_gate.tscn")

## Resource path for grey material.
const GREY_MATERIAL: StandardMaterial3D = preload("res://assets/materials/grey.tres")

## The type of this quantum gate.
@export var type: Type

## A 2x2 matrix representing the quantum gate's transformation.
var _matrix: PackedVector2Array

## The mesh instance holding a TextMesh.
@onready var _base: Node3D = $Base


## Initialize text mesh and matrix
func _ready() -> void:
    # Create text mesh representing gate
    var mesh_instance = MeshInstance3D.new()
    mesh_instance.position.y = 0.1
    mesh_instance.rotation_degrees.x = -90
    var text_mesh: TextMesh = TextMesh.new()
    text_mesh.material = GREY_MATERIAL
    text_mesh.font_size = 96
    text_mesh.depth = 0.1
    text_mesh.text = type_to_string(type)
    mesh_instance.mesh = text_mesh
    _base.add_child(mesh_instance)

    # Set correct matrix
    _matrix = type_to_matrix(type)


## Returns a string representation of the quantum gate type.
static func type_to_string(type: Type) -> String:
    match type:
        Type.IDENTITY:
            return "I"
        Type.HADAMARD:
            return "H"
        Type.PAULI_X:
            return "X"
        Type.PAULI_Y:
            return "Y"
        Type.PAULI_Z:
            return "Z"
        Type.PI_OVER_8:
            return "T​"
        _:
            return "?"


## Gets the matrix representing the quantum gate type.
static func type_to_matrix(type: Type) -> PackedVector2Array:
    match type:
        Type.HADAMARD:
            return [
                Vector2(1 / sqrt(2), 0.0), Vector2(1 / sqrt(2), 0.0),
                Vector2(1 / sqrt(2), 0.0), Vector2(-1 / sqrt(2), 0.0)
            ]
        Type.PAULI_X:
            return [
                Vector2(0.0, 0.0), Vector2(1.0, 0.0),
                Vector2(1.0, 0.0), Vector2(0.0, 0.0)
            ]
        Type.PAULI_Y:
            return [
                Vector2(0.0, 0.0), Vector2(0.0, -1.0),
                Vector2(0.0, 1.0), Vector2(0.0, 0.0)
            ]
        Type.PAULI_Z:
            return [
                Vector2(1.0, 0.0), Vector2(0.0, 0.0),
                Vector2(0.0, 0.0), Vector2(-1.0, 0.0)
            ]
        Type.PI_OVER_8:
            return [
                Vector2(1, 0), Vector2(0, 0),
                Vector2(0, 0), Vector2(1 / sqrt(2), 1 / sqrt(2))
            ]
        _:
            return [
                Vector2(1.0, 0.0), Vector2(0.0, 0.0),
                Vector2(0.0, 0.0), Vector2(1.0, 0.0)
            ]


## Applies the quantum gate to the input qubit and propagates the result to the output qubit.
func propagate(qubit_in: Qubit, qubit_out: Qubit) -> void:
    qubit_out.alpha = Vector2(
        # Real part of new α
        _matrix[0].x * qubit_in.alpha.x - _matrix[0].y * qubit_in.alpha.y + _matrix[1].x * qubit_in.beta.x - _matrix[1].y * qubit_in.beta.y,
        # Imaginary part of new α
        _matrix[0].x * qubit_in.alpha.y + _matrix[0].y * qubit_in.alpha.x + _matrix[1].x * qubit_in.beta.y + _matrix[1].y * qubit_in.beta.x
    )
    qubit_out.beta = Vector2(
        # Real part of new β
        _matrix[2].x * qubit_in.alpha.x - _matrix[2].y * qubit_in.alpha.y + _matrix[3].x * qubit_in.beta.x - _matrix[3].y * qubit_in.beta.y,
        # Imaginary part of new β
        _matrix[2].x * qubit_in.alpha.y + _matrix[2].y * qubit_in.alpha.x + _matrix[3].x * qubit_in.beta.y + _matrix[3].y * qubit_in.beta.x
    )
    qubit_out.propagate()
