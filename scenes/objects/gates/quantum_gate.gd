## Represents a quantum gate that can apply transformations to a qubit using a defined matrix.
class_name QuantumGate extends Interactable

## The input qubit of the quantum gate.
@export var qubit_in: Qubit:
    set = _set_qubit_in
## The output qubit of the quantum gate.
@export var qubit_out: Qubit:
    set = _set_qubit_out

## A 2x2 matrix representing the quantum gate's transformation.
var _matrix: PackedVector2Array


func _set_qubit_in(value: Qubit) -> void:
    qubit_in = value
    if qubit_in and qubit_out:
        apply()


func _set_qubit_out(value: Qubit) -> void:
    qubit_out = value
    if qubit_in and qubit_out:
        apply()


## Applies the quantum gate to input qubit and stores the result in the output qubit.
func apply() -> void:
    _apply(qubit_in, qubit_out)


## Applies the quantum gate to input qubit and stores the result in the output qubit.
func _apply(input: Qubit, output: Qubit) -> void:
    output.alpha = Vector2(
        # Real part of new α
        _matrix[0].x * input.alpha.x - _matrix[0].y * input.alpha.y + _matrix[1].x * input.beta.x - _matrix[1].y * input.beta.y,  
        # Imaginary part of new α
        _matrix[0].x * input.alpha.y + _matrix[0].y * input.alpha.x + _matrix[1].x * input.beta.y + _matrix[1].y * input.beta.x   
    )
    output.beta = Vector2(
        # Real part of new β
        _matrix[2].x * input.alpha.x - _matrix[2].y * input.alpha.y + _matrix[3].x * input.beta.x - _matrix[3].y * input.beta.y,  
        # Imaginary part of new β
        _matrix[2].x * input.alpha.y + _matrix[2].y * input.alpha.x + _matrix[3].x * input.beta.y + _matrix[3].y * input.beta.x   
    )
    output.update()
