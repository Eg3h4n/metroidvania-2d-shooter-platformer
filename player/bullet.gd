extends AnimatedSprite2D

var bullet_impact_effect = preload("res://player/bullet_impact_effect.tscn")

var speed : int = 600
var direction : int
var damage_amount : int = 1
var move_x_direction : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _physics_process(delta: float) -> void:
	if move_x_direction:
		move_local_x(direction * speed * delta)
	else:
		move_local_y(direction * speed * delta)
	
func _on_timer_timeout() -> void:
	queue_free()
	
func _on_hit_box_area_entered(area: Area2D) -> void:
	print("hit box area entered")
	bullet_impact()
	
func _on_hit_box_body_entered(body: Node2D) -> void:
	print("body entered")
	bullet_impact()
	
func get_damage_amount() -> int:
	return damage_amount
	
func bullet_impact():
	var bullet_impact_effect_instance = bullet_impact_effect.instantiate() as Node2D
	bullet_impact_effect_instance.global_position = global_position
	get_parent().add_child(bullet_impact_effect_instance)
	queue_free()
