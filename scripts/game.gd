extends Node3D

var wood: int = 0
var leaving: bool = false
var left: bool = false
var dead: bool = false

@onready var craft_area: Node3D = $Scenery/Island/CraftArea
@onready var raft: Node3D = $Scenery/Sea/Raft
@onready var player: Player = $Player
@onready var finished_player: Node3D = $Scenery/Sea/Raft/player
@onready var cam: CamChase = $Camera3D
@onready var goal: Node3D = $Goal
@onready var goal_label: Label = $UI/GoalLabel
@onready var gameover_label: Label = $UI/GameoverLabel

func _ready():
	craft_area.set_process(false)
	
func _process(delta):
	if leaving:
		if raft != null:
			raft.global_position.x += 5 * delta
		if not left and raft.global_position.x > goal.position.x:
			left = true
			goal_label.visible = true
			cam.stop_chasing()
			await  get_tree().create_timer(5).timeout
			raft.queue_free()
	
func _on_wood_collected():
	wood += 1
	if wood == 5:
		craft_area.set_process(true)
		craft_area.visible = true
		player.can_craft = true
		
func _on_craft_started():
	craft_area.visible = false
	
func _on_craft_done():
	raft.visible = true
	await get_tree().create_timer(3).timeout
	cam.target = raft
	player.queue_free()
	finished_player.visible = true
	await get_tree().create_timer(1).timeout
	leaving = true
	
func _input(event):
	if (left or dead) and event is InputEventKey and event.is_pressed():
		if event.is_action_pressed("quit"):
			get_tree().quit()
		else:
			get_tree().reload_current_scene()
			
func _on_player_dead():
	await get_tree().create_timer(2).timeout
	dead = true
	gameover_label.visible = true
