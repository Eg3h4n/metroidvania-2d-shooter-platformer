extends Node2D

@export var scene_to_transition: String

func _on_exit_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var player = body as CharacterBody2D
		player.queue_free()
		
	await get_tree().create_timer(3.0).timeout
	print("scene transition")
	SceneManager.transition_to_scene(scene_to_transition)
