## Represents a Pauli-Z quantum gate.
class_name PauliZGate extends QuantumGate

## Resource path for creating instances of the scene.
const SCENE: PackedScene = preload("res://scenes/objects/gates/pauli_z_gate/pauli_z_gate.tscn")


func _init() -> void:
	_matrix = [
		Vector2(1.0, 0.0), Vector2(0.0, 0.0),
		Vector2(0.0, 0.0), Vector2(-1.0, 0.0)
	]
