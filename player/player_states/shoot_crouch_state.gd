extends NodeState

var bullet = preload("res://player/bullet.tscn")

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var muzzle: Marker2D

func on_process(delta : float):
	pass

func on_physics_process(delta : float):
	if GameInputEvents.shoot_input():
		gun_shooting()
	
	# transition states
	# idle state
	# run state
	var direction : float = GameInputEvents.movement_input()
	
	if direction and character_body_2d.is_on_floor():
		transition.emit("Run")
	# jump state
	if GameInputEvents.jump_input():
		transition.emit("Jump")
	# shoot up state
	if GameInputEvents.shoot_up_input():
		transition.emit("ShootUp")

func enter():
	muzzle.position = Vector2(17, -14) if !animated_sprite_2d.flip_h else Vector2(-17, -14)
	#get_tree().create_timer(hold_gun_time).timeout.connect(on_hold_gun_timeout)
	animated_sprite_2d.play("shoot_crouch")

func exit():
	animated_sprite_2d.stop()
	
func on_hold_gun_timeout():
	transition.emit("Idle")

func gun_shooting():
	var direction : float = -1 if animated_sprite_2d.flip_h else 1
	
	var bullet_instance = bullet.instantiate() as Node2D
	bullet_instance.direction = direction
	bullet_instance.move_x_direction = true
	bullet_instance.global_position = muzzle.global_position
	get_parent().add_child(bullet_instance)
