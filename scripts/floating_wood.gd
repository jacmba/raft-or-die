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
	get_tree().call_group("message_listeners", "_on_message_show", "Press action button to collect wood")
	
func _on_player_retired(body):
	player = null
	if connected:
		connected = false
		player = body as Player
		player.action_pressed.disconnect(_on_action_pressed)
		get_tree().call_group("message_listeners", "_on_message_hide")
	
func _on_action_pressed():
	if player != null and not player.has_wood:
		player.collect_wood()
	queue_free()
