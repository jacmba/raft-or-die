extends Camera3D

class_name CamChase

@export var target: Node3D

@onready var offset = position.z - target.position.z

func _process(delta):
	var z = target.global_position.z + offset
	var x = target.global_position.x
	
	position.x = lerp(position.x, x, delta * 5)
	position.z = lerp(position.z, z, delta * 5)
