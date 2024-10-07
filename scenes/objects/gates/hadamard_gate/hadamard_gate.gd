## Represents an hadamard quantum gate.
class_name HadamardGate extends QuantumGate


func _init():
    var sqrt_2_inv = 1.0 / sqrt(2.0)
    _matrix = [
        Vector2(sqrt_2_inv, 0.0), Vector2(sqrt_2_inv, 0.0),
        Vector2(sqrt_2_inv, 0.0), Vector2(-sqrt_2_inv, 0.0)
    ]
