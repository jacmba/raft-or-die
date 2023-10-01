extends Camera3D

@export var target: Node3D

@onready var offset = position.z - target.position.z

func _process(delta):
	var z = target.position.z + offset
	var x = target.position.x
	
	position.x = lerp(position.x, x, delta * 5)
	position.z = lerp(position.z, z, delta * 5)
