extends CharacterBody3D

class_name Player

const speed: float = 400
const gravity: float = 100
const rot_speed: float = 10

@onready var anim: AnimationPlayer = $AnimationPlayer

var in_water: bool = false
var dead: bool = false
var health = 10
var hunger = 10

# Process logic on physics sync
func _physics_process(delta):
	# Process gravity
	velocity.y -= gravity * delta
	
	# Do nothing when dead
	if dead:
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
	if movement.length() > 0:
		if anim.current_animation != "Run":
			anim.play("Run")
	elif anim.current_animation != "Idle":
		anim.play("Idle")
	
	# Normalize movement
	movement *= speed * delta
	velocity.x = movement.x
	velocity.z = movement.y
	
	move_and_slide()
	
func _on_water_entered(_body):
	in_water = true

func _on_water_exited(_body):
	in_water = false
	
func take_bite():
	health -= 1
	get_tree().call_group("health_listeners", "_on_health_updated", health)
	if health <= 0:
		dead = true
		anim.play("Die")
