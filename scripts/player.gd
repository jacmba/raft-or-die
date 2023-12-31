extends CharacterBody3D

class_name Player

signal action_pressed
signal wood_collected
signal wood_picked
signal craft_started
signal craft_done
signal player_dead

const speed: float = 400
const gravity: float = 100
const rot_speed: float = 10

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var hunger_timer: Timer = $HungerTimer
@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

@onready var splash_sound: AudioStream = preload("res://110393__soundscalpelcom__water_splash.wav")
@onready var eat_sound: AudioStream = preload("res://sound/412068__inspectorj__chewing-carrot-a.wav")
@onready var death_sound: AudioStream = preload("res://sound/253478__thatguywiththebeard__death-i.wav")
@onready var wood_collect_sound: AudioStream = preload("res://sound/348112__matrixxx__crunch.wav")

var in_water: bool = false
var in_craft_area: bool = false
var dead: bool = false
var crafting: bool = false
var has_wood: bool = false
var can_craft: bool = false
var eating: bool = false
var health = 10
var hunger = 10
var surface_multiplier = 1
var energy_multiplier = 1

func _ready():
	anim_tree.active = true

# Process by frame
func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		
	if dead:
		return
		
	if Input.is_action_just_pressed("perform_action"):
		if in_craft_area:
			if can_craft:
				crafting = true
				anim_tree.active = false
				anim.play("Craft")
				craft_started.emit()
				hunger_timer.stop()
				await get_tree().create_timer(5).timeout
				anim.play("Idle")
				craft_done.emit()
			elif has_wood:
				anim_tree.active = false
				anim.play("Drop")
				await anim.animation_finished
				audio_player.stream = wood_collect_sound
				audio_player.play()
				wood_collected.emit()
				anim_tree.active = true
				has_wood = false
		else:
			action_pressed.emit()

# Process logic on physics sync
func _physics_process(delta):
	# Process gravity (float on water)
	if not in_water or position.y > -0.3 :
		velocity.y -= gravity * delta
		motion_mode = CharacterBody3D.MOTION_MODE_GROUNDED
	else:
		velocity.y = 0
		motion_mode = CharacterBody3D.MOTION_MODE_FLOATING
	
	# Do nothing when dead
	if dead or crafting or eating:
		return
	
	var movement: Vector2 = Vector2.ZERO
	var turn: float = rotation.y
	
	# Check horizontal input
	if Input.is_action_pressed("move_left"):
		movement.x = -1
		turn = - PI / 2
	elif Input.is_action_pressed("move_right"):
		movement.x = 1
		turn = PI / 2
	
	# Check vertical input
	if Input.is_action_pressed("move_forward"):
		movement.y = -1
		turn = PI
	elif Input.is_action_pressed("move_backwards"):
		movement.y = 1
		turn = 0
		
	# Update rotation
	rotation.y = lerp_angle(rotation.y, turn, rot_speed * delta)
		
	# Update animation
	anim_tree.set("parameters/conditions/walking", movement.length() > 0)
	anim_tree.set("parameters/conditions/stopping", movement.length() == 0.0)
	anim_tree.set("parameters/conditions/in_water", in_water and position.y <= -0.3)
	anim_tree.set("parameters/conditions/off_water", not in_water)
	anim_tree.set("parameters/conditions/wood_on", has_wood)
	
	# Normalize movement
	movement *= speed * delta * surface_multiplier * energy_multiplier
	velocity.x = clampf(movement.x, -6, 6)
	velocity.z = clampf(movement.y, -6, 6)
	
	move_and_slide()
	
func _on_water_entered(_body):
	in_water = true
	surface_multiplier = 0.7
	audio_player.stream = splash_sound
	audio_player.play()

func _on_water_exited(_body):
	in_water = false
	surface_multiplier = 1
	audio_player.stream = splash_sound
	audio_player.play()
	
func _on_hunger_increase():
	if hunger > 0:
		hunger -= 1
		get_tree().call_group("hunger_listeners", "_on_hunger_updated", hunger)
		energy_multiplier = hunger / 10.0
		energy_multiplier = clampf(energy_multiplier, 0.1, 1.0)
	else:
		take_bite() # Just reuse method to decrease health
	
func take_bite():
	if health > 0:
		health -= 1
		get_tree().call_group("health_listeners", "_on_health_updated", health)
	else:
		dead = true
		audio_player.stream = death_sound
		audio_player.play()
		anim_tree.active = false
		anim.play("Die")
		hunger_timer.stop()
		await anim.animation_finished
		player_dead.emit()
		
func eat():
	if hunger < 10:
		hunger = 10
		get_tree().call_group("hunger_listeners", "_on_hunger_updated", hunger)
		audio_player.stream = eat_sound
		audio_player.play()
		energy_multiplier = 10
		hunger_timer.stop()
		eating = true
		anim_tree.active = false
		anim.play("Eating")
		await anim.animation_finished
		eating = false
		anim_tree.active = true
		hunger_timer.start()
		
func collect_wood():
	has_wood = true
	audio_player.stream = wood_collect_sound
	audio_player.play()
	wood_picked.emit()
	
func _on_craft_area_entered(_body):
	in_craft_area = true
	if not can_craft:
		if has_wood:
			get_tree().call_group("message_listeners", "_on_message_show", "Press action to drop wood")
		return
	get_tree().call_group("message_listeners", "_on_message_show", "Press action button to start crafting")
	
func _on_craft_area_exit(_body):
	get_tree().call_group("message_listeners", "_on_message_hide")
	in_craft_area = false
