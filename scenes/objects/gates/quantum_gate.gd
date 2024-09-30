## Represents a quantum gate that can apply transformations to a qubit using a defined matrix.
class_name QuantumGate extends Interactable

## The input qubit of the quantum gate.
@export var qubit_in: Qubit:
    set = _set_qubit_in
## The output qubit of the quantum gate.
@export var qubit_out: Qubit:
    set = _set_qubit_out

## A 2x2 matrix representing the quantum gate's transformation.
var _matrix: PackedFloat32Array


func _set_qubit_in(value: Qubit):
    qubit_in = value
    if qubit_in and qubit_out:
        apply()


func _set_qubit_out(value: Qubit):
    qubit_out = value
    if qubit_in and qubit_out:
        apply()


## Applies the quantum gate to input qubit and stores the result in the output qubit.
func apply():
    qubit_out.alpha = Vector2(
        _matrix[0] * qubit_in.alpha.x + _matrix[1] * qubit_in.beta.x,
        _matrix[0] * qubit_in.alpha.y + _matrix[1] * qubit_in.beta.y
    )
    qubit_out.beta = Vector2(
        _matrix[2] * qubit_in.alpha.x + _matrix[3] * qubit_in.beta.x,
        _matrix[2] * qubit_in.alpha.y + _matrix[3] * qubit_in.beta.y
    )
    qubit_out.update()
