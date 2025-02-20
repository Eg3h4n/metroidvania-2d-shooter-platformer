extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var scene_to_transition: String
@export var key_id : String

var door_open : bool

func _on_exit_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var player = body as CharacterBody2D
		player.queue_free()
		
	await get_tree().create_timer(3.0).timeout
	print("scene transition")
	SceneManager.transition_to_scene(scene_to_transition)


func _on_unlock_door_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var has_item : bool = InventoryManager.has_inventory_item(key_id)
		
		if !has_item:
			return
		
		if !door_open:
			animated_sprite_2d.play("open")
			door_open = true
			collision_shape_2d.set_deferred("disabled", true)


func _on_unlock_door_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if door_open:
			animated_sprite_2d.play("close")
			door_open = false
			
