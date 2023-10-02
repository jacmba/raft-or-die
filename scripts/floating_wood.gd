extends Node3D

class_name  FloatingWood

var connected: bool = false
var player: Player = null

func _ready():
	rotation.y = randf_range(0.0, 2.0 * PI)
	
func _on_player_close(body):
	player = body as Player
	connected = true
	player.action_pressed.connect(_on_action_pressed)
	
func _on_player_retired(body):
	player = null
	if connected:
		connected = false
		var player: Player = body as Player
		player.action_pressed.disconnect(_on_action_pressed)
	
func _on_action_pressed():
	if player != null:
		player.collect_wood()
	queue_free()
