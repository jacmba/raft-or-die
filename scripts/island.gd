extends Node3D

class_name Island

const sink_rate: float = .5

@onready var target_height: float = position.y

func _physics_process(delta):
	position.y = lerpf(position.y, target_height, delta)

func _on_sink():
	$AnimationPlayer.play("quake")
	target_height -= sink_rate
