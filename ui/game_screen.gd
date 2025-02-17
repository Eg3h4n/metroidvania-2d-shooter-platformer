extends CanvasLayer

@onready var collectible_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/CollectibleLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CollectibleManager.on_collectible_award_received.connect(on_collectable_award_received)
	
func on_collectable_award_received(total_amount : int):
	collectible_label.text = str(total_amount)
