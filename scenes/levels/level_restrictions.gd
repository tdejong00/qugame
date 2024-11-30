extends Node

## Maximum amount of allowed gates in the circuit.
var size_limit: int = 1

## Each bit of the mask represents whether that type is allowed.
## For example: the bit string `00010010` (`18`) corresponds to
## the Z and H gates being allowed.
var _allowed_gates_mask: int = 0


## Determines whether the gate is allowed using the allowed gates mask.
func is_gate_allowed(type: QuantumGate.Type) -> bool:
    return _allowed_gates_mask & (2 ** type)


## Updates the allowed gates mask to allow the specified gate.
func allow_gate(type: QuantumGate.Type) -> void:
    _allowed_gates_mask |= (2 ** type)
