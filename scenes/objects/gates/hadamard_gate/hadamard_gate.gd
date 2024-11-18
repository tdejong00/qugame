## Represents an hadamard quantum gate.
class_name HadamardGate extends QuantumGate

## Resource path for creating instances of the scene.
const SCENE: PackedScene = preload("res://scenes/objects/gates/hadamard_gate/hadamard_gate.tscn")

func _init() -> void:
	var sqrt_2_inv = 1.0 / sqrt(2.0)
	_matrix = [
		Vector2(sqrt_2_inv, 0.0), Vector2(sqrt_2_inv, 0.0),
		Vector2(sqrt_2_inv, 0.0), Vector2(-sqrt_2_inv, 0.0)
	]
