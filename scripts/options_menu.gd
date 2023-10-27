extends Node2D

class_name OptionsMenu

var model: Options

@onready var difficulty: Label = $VBoxContainer/GridContainer/HBoxContainer/DifficultyLabel

func _ready():
	model = Options.get_instance()
	$VBoxContainer/GridContainer/MusicCheck.button_pressed = model.music
	$VBoxContainer/GridContainer/SfxCheck.button_pressed = model.sfx
	update_difficulty()

func _on_music_toggle(pressed: bool):
	AudioServer.set_bus_mute(1, not pressed)
	model.music = pressed
	
func _on_sfx_toggle(pressed: bool):
	AudioServer.set_bus_mute(2, not pressed)
	model.sfx = pressed
	
func _on_back_click():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func update_difficulty():
	difficulty.text = model.get_difficulty()
	
func _on_difficulty_decrease():
	model.decrease_difficulty()
	update_difficulty()
	
func _on_difficulty_increase():
	model.increase_difficulty()
	update_difficulty()
