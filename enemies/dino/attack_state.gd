extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D
@export var speed : int = 50

var player : CharacterBody2D
var max_speed : int

func on_process(delta : float):
	pass
	
func on_physics_process(delta : float):
	var direction : int = -1 if character_body_2d.global_position > player.global_position else 1
	animated_sprite_2d.flip_h = character_body_2d.global_position < player.global_position
	
	animated_sprite_2d.play("attack")
	character_body_2d.velocity.x += direction * speed * delta
	character_body_2d.velocity.x = clamp(character_body_2d.velocity.x, -speed, max_speed)
	character_body_2d.move_and_slide()
	
func enter():
	player = get_tree().get_nodes_in_group("Player")[0] as CharacterBody2D
	max_speed = speed + 20
func exit():
	pass
