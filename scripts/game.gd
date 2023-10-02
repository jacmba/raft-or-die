extends Node3D

var wood: int = 0
var leaving: bool = false

@onready var craft_area: Node3D = $Scenery/Island/CraftArea
@onready var raft: Node3D = $Scenery/Sea/Raft
@onready var player: Player = $Player
@onready var finished_player: Node3D = $Scenery/Sea/Raft/player
@onready var cam: CamChase = $Camera3D

func _ready():
	craft_area.set_process(false)
	
func _process(delta):
	if leaving:
		raft.global_position.x += 10 *delta
	
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
