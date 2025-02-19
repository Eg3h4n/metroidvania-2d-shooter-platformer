extends CharacterBody2D

var bullet = preload("res://player/bullet.tscn")
var player_death_effect = preload("res://player/player_death_effect/player_death_effect.tscn")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var muzzle: Marker2D = $Muzzle
@onready var hurt_animation_player: AnimationPlayer = $HurtAnimationPlayer

@export var SPEED : int = 1000
@export var MAX_HORIZONTAL_SPEED : int = 300
@export var SLOW_DOWN_SPEED : int = 1500
@export var JUMP_VELOCITY : int = -400
@export var JUMP_HORIZONTAL_SPEED : int = 1000
@export var MAX_JUMP_HORIZONTAL_SPEED : int = 300
@export var jump_count : int = 1

enum State {Idle, Run, Jump, Shoot}
var current_state : State
var muzzle_position
var current_jump_count : int

func _ready() -> void:
	current_state = State.Idle
	muzzle_position = muzzle.position

func _physics_process(delta: float) -> void:
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	set_player_muzzle_position()
	player_shooting(delta)
	
	move_and_slide()
	
	player_animations()
	#print("State ", State.keys()[current_state])
	
func player_falling(delta: float):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
func player_idle(delta: float):
	if is_on_floor():
		current_state = State.Idle
		#print("State ", State.keys()[current_state])
		
func player_run(delta: float):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = get_input_movement()
	if direction:
		velocity.x += direction * SPEED * delta
		velocity.x = clamp(velocity.x, -MAX_HORIZONTAL_SPEED, MAX_HORIZONTAL_SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SLOW_DOWN_SPEED * delta)
		
	if direction != 0 and is_on_floor():
		current_state = State.Run
		animated_sprite_2d.flip_h = direction < 0 
		#print("State ", State.keys()[current_state])
		
func player_jump(delta: float):
	var jump_input : bool = Input.is_action_just_pressed("jump")
	# Handle jump.
	if jump_input and is_on_floor():
		current_jump_count = 0
		velocity.y = JUMP_VELOCITY
		current_jump_count += 1
		current_state = State.Jump
		
	if !is_on_floor() and jump_input and current_jump_count < jump_count:
		velocity.y = JUMP_VELOCITY
		current_jump_count += 1
		current_state = State.Jump
		
	if !is_on_floor() and current_state == State.Jump:
		var direction = get_input_movement()
		velocity.x += direction * JUMP_HORIZONTAL_SPEED * delta
		velocity.x = clamp(velocity.x, -MAX_JUMP_HORIZONTAL_SPEED, MAX_JUMP_HORIZONTAL_SPEED)
		
func player_shooting(delta : float):
	var direction = get_input_movement()
	
	if direction != 0 and Input.is_action_just_pressed("shoot"):
		var bullet_instance = bullet.instantiate() as Node2D
		bullet_instance.direction = direction
		bullet_instance.global_position = muzzle.global_position
		get_parent().add_child(bullet_instance)
		current_state = State.Shoot
		
func set_player_muzzle_position():
	var direction = get_input_movement()
	
	if direction > 0:
		muzzle.position.x = muzzle_position.x
	elif direction < 0:
		muzzle.position.x = -muzzle_position.x
	
func player_animations():
	if current_state == State.Idle:
		animated_sprite_2d.play("idle")
	elif current_state == State.Run and animated_sprite_2d.animation != "run_shoot":
		animated_sprite_2d.play("run")
	elif current_state == State.Jump:
		animated_sprite_2d.play("jump")
	elif current_state == State.Shoot:
		animated_sprite_2d.play("run_shoot")
		
func player_death():
	var player_death_effect_instance = player_death_effect.instantiate() as Node2D
	player_death_effect_instance.global_position = global_position
	get_parent().add_child(player_death_effect_instance)
	queue_free()
	
func get_input_movement() -> float:
	var direction : float = Input.get_axis("move_left", "move_right")
	return direction


func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		print("enemy entered and hit for ", body.damage_amount)
		hurt_animation_player.play("hurt")
		HealthManager.decrease_health(body.damage_amount)
		
	if HealthManager.current_health == 0:
		player_death()
		
