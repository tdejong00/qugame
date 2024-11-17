## Represents a quantum gate that can apply transformations to a qubit using a defined matrix.
class_name QuantumGate extends Node3D

## A 2x2 matrix representing the quantum gate's transformation.
var _matrix: PackedVector2Array


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
