## Represents a quantum gate that can apply transformations to a qubit using a defined matrix.
class_name QuantumGate extends Node3D

## A 2x2 matrix representing the quantum gate's transformation.
var _matrix: PackedFloat32Array


## Applies the quantum gate to the specified qubit.
## Returns a new qubit with the transformation applied.
func apply_to(qubit: Qubit) -> Qubit:
    var alpha = Vector2(
        _matrix[0] * qubit.alpha.x + _matrix[1] * qubit.beta.x,
        _matrix[0] * qubit.alpha.y + _matrix[1] * qubit.beta.y
    )
    var beta = Vector2(
        _matrix[2] * qubit.alpha.x + _matrix[3] * qubit.beta.x,
        _matrix[2] * qubit.alpha.y + _matrix[3] * qubit.beta.y
    )
    return Qubit.create(alpha, beta)
