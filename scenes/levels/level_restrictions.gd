extends Node

## Maximum amount of allowed gates in the circuit, with -1 representing no limit.
var size_limit: int = -1

## Each bit of the mask represents whether that type is allowed.
## For example: the bit string `00010010` (`18`) corresponds to
## the Z and H gates being allowed.
var _allowed_gates_mask: int = 0


## Updates the allowed gates mask to allow the specified gate.
func allow_gate(type: QuantumGate.Type) -> void:
	_allowed_gates_mask |= (2 ** type)


## Updates the allowed gates mask to allow all gates.
func allow_all() -> void:
	_allowed_gates_mask = (2 ** QuantumGate.Type.size()) - 1


## Resets the restrictions.
func reset():
	size_limit = 1
	_allowed_gates_mask = 0


## Determines whether the specified size is allowed.
func is_size_allowed(size: int) -> bool:
	return size_limit == -1 or size < size_limit


## Determines whether the gate is allowed using the allowed gates mask.
func is_gate_allowed(type: QuantumGate.Type) -> bool:
	return _allowed_gates_mask & (2 ** type)
