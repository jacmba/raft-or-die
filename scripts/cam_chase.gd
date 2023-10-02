extends Camera3D

class_name CamChase

@export var target: Node3D

@onready var offset = position.z - target.position.z

var chasing: bool = true

func _process(delta):
	if not chasing:
		return
		
	var z = target.global_position.z + offset
	var x = target.global_position.x
	
	position.x = lerp(position.x, x, delta * 5)
	position.z = lerp(position.z, z, delta * 5)
	
func stop_chasing():
	chasing = false
