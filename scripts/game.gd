extends Node3D

var wood: int = 0
var leaving: bool = false
var left: bool = false
var dead: bool = false
var freeze_message: bool = false

@onready var craft_area: Node3D = $Scenery/Island/CraftArea
@onready var raft: Node3D = $Scenery/Sea/Raft
@onready var player: Player = $Player
@onready var finished_player: Node3D = $Scenery/Sea/Raft/player
@onready var fp_anim_tree: AnimationTree = $Scenery/Sea/Raft/player/AnimationTree
@onready var cam: CamChase = $Camera3D
@onready var goal: Node3D = $Goal
@onready var goal_label: Label = $UI/GoalLabel
@onready var gameover_label: Label = $UI/GameoverLabel
@onready var message_label: Label = $UI/MessageLabel
@onready var win_jingle: AudioStream = preload("res://sound/270402__littlerobotsoundfactory__jingle_win_00.wav")
@onready var lose_jingle: AudioStream = preload("res://sound/270403__littlerobotsoundfactory__jingle_lose_00.wav")
@onready var soundtrack: AudioStreamPlayer2D = $"Background sound/Soundtrack"
@onready var chimes: AudioStreamPlayer2D = $"Background sound/Chimes"
@onready var all_wood_sound: AudioStream = preload("res://sound/592346__axilirate__collect-crystal.wav")

func _ready():
	craft_area.set_process(false)
	
func _process(delta):
	if leaving:
		if raft != null:
			raft.global_position.x += 5 * delta
		if not left and raft.global_position.x > goal.position.x:
			fp_anim_tree.set("parameters/conditions/dance", true)
			left = true
			goal_label.visible = true
			cam.stop_chasing()
			soundtrack.stream = win_jingle
			soundtrack.play()
			await  get_tree().create_timer(5).timeout
			raft.queue_free()
			
func _on_wood_picked():
	_on_message_show("Drop wood in crafting area")
	craft_area.visible = true
	
func _on_wood_collected():
	wood += 1
	if wood == 5:
		freeze_message = true
		craft_area.set_process(true)
		player.can_craft = true
		message_label.text = "Wood gathering complete.\nYou can now build the raft"
		chimes.stream = all_wood_sound
		chimes.play()
		await get_tree().create_timer(5).timeout
		message_label.text = ""
		freeze_message = false
	else:
		craft_area.visible = false
		
func _on_craft_started():
	craft_area.visible = false
	
func _on_craft_done():
	raft.visible = true
	await get_tree().create_timer(3).timeout
	if not player.dead:
		soundtrack.stop()
		cam.target = raft
		player.queue_free()
		finished_player.visible = true
		fp_anim_tree.active = true
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
	soundtrack.stop()
	soundtrack.stream = win_jingle
	soundtrack.play()
	
func _on_message_show(message: String):
	message_label.text = message
	await get_tree().create_timer(3).timeout
	_on_message_hide()
	
func _on_message_hide():
	if not freeze_message:
		message_label.text = ""
