extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
@export_category("Fall State")
@export var coyote_time : float = 0.5

const GRAVITY: int = 800
var coyote_jump : bool

func on_process(delta : float):
	pass
	
func on_physics_process(delta : float):
	if !character_body_2d.is_on_floor():
		get_coyote_time()
		character_body_2d.velocity.y += GRAVITY * delta
	
	character_body_2d.move_and_slide()
	
	#transition states
	#idle state
	if character_body_2d.is_on_floor():
		transition.emit("Idle")
	if coyote_jump and GameInputEvents.jump_input():
		transition.emit("Jump")
	
func enter():
	animated_sprite_2d.play("fall")
	coyote_jump = true
	
func exit():
	animated_sprite_2d.stop()

func get_coyote_time():
	await get_tree().create_timer(coyote_time).timeout
	coyote_jump = false
