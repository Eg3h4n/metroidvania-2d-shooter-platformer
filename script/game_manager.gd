extends Node

const MAIN_MENU_SCREEN = preload("res://ui/main_menu_screen.tscn")
const PAUSE_MENU_SCREEN = preload("res://ui/pause_menu_screen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.44, 0.12, 0.53, 1.00))
	
	SettingsManager.load_settings()
	
func start_game():
	if get_tree().paused:
		get_tree().paused = false
		get_tree().reload_current_scene()
		return
		
	SceneManager.transition_to_scene("Level1")
	
func exit_game():
	get_tree().quit()
	
func pause_game():
	get_tree().paused = true
	
	var pasue_menu_screen_instance = PAUSE_MENU_SCREEN.instantiate()
	get_tree().root.add_child(pasue_menu_screen_instance)
	
func continue_game():
	get_tree().paused = false
	
func main_menu():
	var main_menu_screen_instance = MAIN_MENU_SCREEN.instantiate()
	get_tree().root.add_child(main_menu_screen_instance)
	
	
