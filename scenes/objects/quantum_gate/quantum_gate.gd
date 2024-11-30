## Represents a quantum gate that can apply transformations to a qubit using a defined matrix.
class_name QuantumGate extends Node3D

## The possible quantum gate types.
enum Type {
    IDENTITY,
    HADAMARD,
    PAULI_X,
    PAULI_Y,
    PAULI_Z,
    ROTATE_X,
    ROTATE_Y,
    ROTATE_Z
}

## Resource path for creating instances of the scene.
const SCENE: PackedScene = preload("res://scenes/objects/quantum_gate/quantum_gate.tscn")

## The type of this quantum gate.
@export var type: Type

## A 2x2 matrix representing the quantum gate's transformation.
var _matrix: PackedVector2Array

## The mesh instance holding a TextMesh.
@onready var _mesh_instance: MeshInstance3D = $Base/TextMeshInstance


## Initialize text mesh and matrix
func _ready() -> void:
    var text_mesh: TextMesh = _mesh_instance.mesh
    text_mesh.text = type_to_string(type)
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
        Type.ROTATE_X:
            return "Rx"
        Type.ROTATE_Y:
            return "Ry"
        Type.ROTATE_Z:
            return "Rz​"
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
        Type.ROTATE_X:
            return [
                Vector2(cos(PI / 8), 0), Vector2(0, -sin(PI / 8)),
                Vector2(0, -sin(PI / 8)), Vector2(cos(PI / 8), 0)
            ]
        Type.ROTATE_Y:
            return [
                Vector2(cos(PI / 8), 0), Vector2(-sin(PI / 8), 0),
                Vector2(sin(PI / 8), 0), Vector2(cos(PI / 8), 0)
            ]
        Type.ROTATE_Z:
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
