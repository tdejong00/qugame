## Represents a quantum gate that can apply transformations to a qubit using a defined matrix.
class_name QuantumGate extends Node3D

## The possible quantum gate types.
enum QuantumGateType {
    IDENTITY,
    HADAMARD,
    PAULI_X,
    PAULI_Y,
    PAULI_Z,
    PI_OVER_8,
}

## Resource path for creating instances of the scene.
const SCENE: PackedScene = preload("res://scenes/objects/quantum_gate/quantum_gate.tscn")

## The type of this quantum gate.
@export var gate_type: QuantumGateType

## The mesh instance holding a TextMesh.
@onready var mesh_instance: MeshInstance3D = $Base/TextMeshInstance

## A 2x2 matrix representing the quantum gate's transformation.
var _matrix: PackedVector2Array


## Initialize text mesh and matrix
func _ready() -> void:
    var text_mesh: TextMesh = mesh_instance.mesh

    match gate_type:
        QuantumGateType.IDENTITY:
            text_mesh.text = "I"
            _matrix = [
                Vector2(1.0, 0.0), Vector2(0.0, 0.0),
                Vector2(0.0, 0.0), Vector2(1.0, 0.0)
            ]
        QuantumGateType.HADAMARD:
            text_mesh.text = "H"
            var sqrt_2_inv = 1.0 / sqrt(2.0)
            _matrix = [
                Vector2(sqrt_2_inv, 0.0), Vector2(sqrt_2_inv, 0.0),
                Vector2(sqrt_2_inv, 0.0), Vector2(-sqrt_2_inv, 0.0)
            ]
        QuantumGateType.PAULI_X:
            text_mesh.text = "X"
            _matrix = [
                Vector2(0.0, 0.0), Vector2(1.0, 0.0),
                Vector2(1.0, 0.0), Vector2(0.0, 0.0)
            ]
        QuantumGateType.PAULI_Y:
            text_mesh.text = "Y"
            _matrix = [
                Vector2(0.0, 0.0), Vector2(0.0, -1.0),
                Vector2(0.0, 1.0), Vector2(0.0, 0.0)
            ]
        QuantumGateType.PAULI_Z:
            text_mesh.text = "Z"
            _matrix = [
                Vector2(1.0, 0.0), Vector2(0.0, 0.0),
                Vector2(0.0, 0.0), Vector2(-1.0, 0.0)
            ]
        QuantumGateType.PI_OVER_8:
            text_mesh.text = "T"
            ## Here we use Euler's formula to decompose e^iπ/4 into real
            ## and imaginary parts, both of value 1 over square root of 2.
            var sqrt_2_inv = 1.0 / sqrt(2.0)
            _matrix = [
                Vector2(1.0, 0.0), Vector2(0.0, 0.0),
                Vector2(0.0, 0.0), Vector2(sqrt_2_inv, sqrt_2_inv)
            ]


## Applies the quantum gate to the input qubit and propagates the result to the output qubit.
func propagate(qubit_in: Qubit, qubit_out) -> void:
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
