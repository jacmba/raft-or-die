extends RigidBody3D

class_name Coconut

var collected: bool = false
var player: Player = null

func _ready():
	$FallTimer.wait_time = randi_range(3, 10)
	$FallTimer.start()
	
func _physics_process(delta):
	if collected:
		position.y += 10 * delta
	elif global_position.y < -1:
		queue_free()
	
func _on_coconut_fall():
	gravity_scale = 1
	
func _on_coconut_collected(body):
	if player == null or not collected and not player.dead and not player.eating and not player.has_wood:
		player = body as Player
		get_tree().call_group("message_listeners", "_on_message_show", "Press action button to eat coconut")
		player.action_pressed.connect(_on_action_pressed)
		
func _on_player_exit(_body):
	if player != null:
		player.action_pressed.disconnect(_on_action_pressed)
		get_tree().call_group("message_listeners", "_on_message_hide")
		
func _on_action_pressed():
	if not collected and player != null and not player.dead and not player.eating and not player.has_wood:
		collected = true
		player.eat()
		queue_free()
