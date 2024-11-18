## Represents a π/8 quantum gate.
class_name Paulipi8Gate extends QuantumGate

## Resource path for creating instances of the scene.
const SCENE: PackedScene = preload("res://scenes/objects/gates/pi_8_gate/pi_8_gate.tscn")


func _init() -> void:
	## Here we use Euler's formula to decompose e^iπ/4 into real and imaginary parts, both
	## of value 1 over square root of 2.
	var sqrt_2_inv = 1.0 / sqrt(2.0)
	_matrix = [
		Vector2(1.0, 0.0), Vector2(0.0, 0.0),
		Vector2(0.0, 0.0), Vector2(sqrt_2_inv, sqrt_2_inv)
	]
