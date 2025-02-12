extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var patrol_points : Node

const SPEED = 800.0
const JUMP_VELOCITY = -400.0

enum State {Idle, Walk}
var current_state : State
var direction : Vector2 = Vector2.LEFT
var number_of_points : int
var point_positions : Array[Vector2]
var current_point : Vector2
var current_point_position : int

func _ready() -> void:
	if patrol_points != null:
		number_of_points = patrol_points.get_children().size()
		for point in patrol_points.get_children():
			point_positions.append(point.global_position)
			current_point = point_positions[current_point_position]
	else:
		print("No patrol points found")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	enemy_idle(delta)
	enemy_walk(delta)
	
	move_and_slide()
	
	enemy_animations()

func enemy_idle(delta: float) -> void:
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		current_state = State.Idle
		
func enemy_walk(delta: float) -> void:
	if abs(position.x - current_point.x) > 0.5:
		velocity.x = direction.x * SPEED * delta
		current_state = State.Walk
	else:
		current_point_position = (current_point_position + 1) % number_of_points
		
	current_point = point_positions[current_point_position]
	
	if current_point.x > position.x:
		direction = Vector2.RIGHT
	else:
		direction = Vector2.LEFT
		
	animated_sprite_2d.flip_h = direction.x > 0
	
func enemy_animations():
	if current_state == State.Idle:
		animated_sprite_2d.play("idle")
	elif current_state == State.Walk:
		animated_sprite_2d.play("walk")
