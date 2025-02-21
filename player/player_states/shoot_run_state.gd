extends NodeState

var bullet = preload("res://player/bullet.tscn")

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var muzzle: Marker2D
@export_category("Run State")
@export var speed := 1000
@export var max_horizontal_speed := 300

func on_process(delta : float):
	pass

func on_physics_process(delta : float):
	var direction : float = GameInputEvents.movement_input()
	if GameInputEvents.shoot_input():
		gun_shooting()
	
	# transition states
	# idle state
	# jump state
	if GameInputEvents.jump_input():
		transition.emit("Jump")
	# shoot up state
	if GameInputEvents.shoot_up_input():
		transition.emit("ShootUp")

func enter():
	muzzle.position = Vector2(18, -26) if !animated_sprite_2d.flip_h else Vector2(-18, -26)

	animated_sprite_2d.play("shoot_run")
	gun_shooting()

func exit():
	animated_sprite_2d.stop()

func gun_shooting():
	var direction : float = -1 if animated_sprite_2d.flip_h else 1
	
	var bullet_instance = bullet.instantiate() as Node2D
	bullet_instance.direction = direction
	bullet_instance.move_x_direction = true
	bullet_instance.global_position = muzzle.global_position
	get_parent().add_child(bullet_instance)
