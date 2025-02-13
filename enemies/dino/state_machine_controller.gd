extends Node

@export var node_finite_state_machine : NodeFiniteStateMachine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_attack_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		node_finite_state_machine.transition_to("attack")


func _on_attack_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		node_finite_state_machine.transition_to("idle")
