extends CanvasLayer

const SETTINGS_MENU_SCREEN = preload("res://ui/settings_menu_screen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	GameManager.start_game()
	queue_free()


func _on_exit_button_pressed() -> void:
	GameManager.exit_game()


func _on_settings_button_pressed() -> void:
	var settings_menu_screen_instance = SETTINGS_MENU_SCREEN.instantiate()
	get_tree().root.add_child(settings_menu_screen_instance)
