extends Node2D

class_name MainMenu

func _on_play():
	get_tree().change_scene_to_file("res://scenes/island_level.tscn")
	
func _on_tutorial():
	pass
	
func _on_options():
	get_tree().change_scene_to_file("res://scenes/options_menu.tscn")
	
func _on_exit():
	get_tree().quit()
