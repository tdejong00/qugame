## Represents a Pauli-Y quantum gate.
class_name PauliYGate extends QuantumGate

## Resource path for creating instances of the scene.
const SCENE: PackedScene = preload("res://scenes/objects/gates/pauli_y_gate/pauli_y_gate.tscn")


func _init() -> void:
    _matrix = [
        Vector2(0.0, 0.0), Vector2(0.0, -1.0),
        Vector2(0.0, 1.0), Vector2(0.0, 0.0)
    ]
