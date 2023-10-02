extends Node3D

class_name PalmTree

@onready var spawn_pos: Node3D = $CoconutSpawn
@onready var coconut_prefab: PackedScene = preload("res://scenes/coconut.tscn")

func _ready():
	$SpawnTimer.wait_time = randi_range(10, 30)
	
func _on_coconut_spawn():
	var coconut: RigidBody3D = coconut_prefab.instantiate() as RigidBody3D
	coconut.position = spawn_pos.position
	add_child(coconut)
	$SpawnTimer.wait_time = randi_range(10, 30)
	$SpawnTimer.start()
