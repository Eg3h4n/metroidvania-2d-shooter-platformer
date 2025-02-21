extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var muzzle: Marker2D

var muzzle_position : Vector2

func on_process(delta : float):
	pass
	
func on_physics_process(delta : float):
	pass
	
func enter():
	muzzle_position = Vector2(18, -26)
	animated_sprite_2d.play("shoot_stand")
	
func exit():
	animated_sprite_2d.stop()
