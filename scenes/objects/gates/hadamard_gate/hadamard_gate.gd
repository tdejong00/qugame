## Represents an hadamard gate quantum gate.
class_name HadamardGate extends QuantumGate

func _init():
    var sqrt_2_inv = 1.0 / sqrt(2.0)
    _matrix = [
        sqrt_2_inv, sqrt_2_inv,
        sqrt_2_inv, -sqrt_2_inv
    ]
