extends NodeState

var bullet = preload("res://player/bullet.tscn")

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var muzzle: Marker2D

var wall_cling_direction: Vector2

func on_process(delta : float):
	pass

func on_physics_process(delta : float):
	character_body_2d.velocity.y = 0
	
	var direction : float = GameInputEvents.movement_input()
	
	if direction == 0 and wall_cling_direction == Vector2.ZERO:
		animated_sprite_2d.flip_h = true
		wall_cling_direction = Vector2.RIGHT
	
	if direction < 0 and wall_cling_direction == Vector2.ZERO:
		animated_sprite_2d.flip_h = false
		wall_cling_direction = Vector2.LEFT
	
	if GameInputEvents.shoot_input():
		gun_shooting()
		
	character_body_2d.move_and_slide()
	# transition states
	# Fall state
	if GameInputEvents.fall_input():
		transition.emit("Fall")
	# idle state
	# run state
	if direction and character_body_2d.is_on_floor():
		transition.emit("Run")
	# jump state
	if GameInputEvents.jump_input():
		transition.emit("Jump")
	# shoot up state
	if GameInputEvents.shoot_up_input():
		transition.emit("ShootUp")

func enter():
	muzzle.position = Vector2(21, -26) if !animated_sprite_2d.flip_h else Vector2(-21, -26)
	animated_sprite_2d.play("shoot_wall_cling")

func exit():
	wall_cling_direction = Vector2.ZERO
	animated_sprite_2d.stop()

func gun_shooting():
	var direction : float = -1 if animated_sprite_2d.flip_h else 1
	
	var bullet_instance = bullet.instantiate() as Node2D
	bullet_instance.direction = direction
	bullet_instance.move_x_direction = true
	bullet_instance.global_position = muzzle.global_position
	get_parent().add_child(bullet_instance)
