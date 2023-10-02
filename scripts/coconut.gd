extends RigidBody3D

class_name Coconut

var collected: bool = false

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
	if not collected:
		collected = true
		var player: Player = body as Player
		player.eat()
		gravity_scale = 0
		$AnimationPlayer.play("collect")
		await $AnimationPlayer.animation_finished
		queue_free()
	
