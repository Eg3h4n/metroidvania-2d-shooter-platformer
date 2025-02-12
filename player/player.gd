extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var SPEED : int = 300
@export var JUMP_VELOCITY : int = -400
@export var JUMP_HORIZONTAL : int = 150

enum State {Idle, Run, Jump}
var current_state : State

func _ready() -> void:
	current_state = State.Idle

func _physics_process(delta: float) -> void:
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	
	move_and_slide()
	
	player_animations()
	print("State ", State.keys()[current_state])
	
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
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction != 0 and is_on_floor():
		current_state = State.Run
		animated_sprite_2d.flip_h = direction < 0 
		#print("State ", State.keys()[current_state])
		
func player_jump(delta: float):
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		current_state = State.Jump
		
	if !is_on_floor() and current_state == State.Jump:
		var direction = get_input_movement()
		velocity.x = direction * JUMP_HORIZONTAL
		
func player_animations():
	if current_state == State.Idle:
		animated_sprite_2d.play("idle")
	elif current_state == State.Run:
		animated_sprite_2d.play("run")
	elif current_state == State.Jump:
		animated_sprite_2d.play("jump")
	
func get_input_movement() -> float:
	var direction : float = Input.get_axis("move_left", "move_right")
	return direction
