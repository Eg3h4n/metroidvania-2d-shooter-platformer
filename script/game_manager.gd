extends Node

const MAIN_MENU_SCREEN = preload("res://ui/main_menu_screen.tscn")
const PAUSE_MENU_SCREEN = preload("res://ui/pause_menu_screen.tscn")
const LEVEL_1 = preload("res://Levels/level_1.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.44, 0.12, 0.53, 1.00))
	
func start_game():
	if get_tree().paused:
		continue_game()
		return
		
	transition_to_scene(LEVEL_1.resource_path)
	
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
	
func transition_to_scene(scene_path : String):
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file(scene_path)
	
