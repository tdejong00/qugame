## Represents a Pauli-X quantum gate.
class_name PauliXGate extends QuantumGate

## Resource path for creating instances of the scene.
const SCENE: PackedScene = preload("res://scenes/objects/gates/pauli_x_gate/pauli_x_gate.tscn")


func _init() -> void:
	_matrix = [
		Vector2(0.0, 0.0), Vector2(1.0, 0.0),
		Vector2(1.0, 0.0), Vector2(0.0, 0.0)
	]
