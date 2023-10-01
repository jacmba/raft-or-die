extends CharacterBody3D

class_name Player

const speed: float = 400
const gravity: float = 300
const rot_speed: float = 30

# Process logic on physics sync
func _physics_process(delta):
	var movement: Vector2 = Vector2.ZERO
	
	# Check horizontal input
	if Input.is_action_pressed("move_left"):
		movement.x = -1
		rotation.y = 270
	elif Input.is_action_pressed("move_right"):
		movement.x = 1
		rotation.y = 90
	
	# Check vertical input
	if Input.is_action_pressed("move_forward"):
		movement.y = -1
		rotation.y = 180
	elif Input.is_action_pressed("move_backwards"):
		movement.y = 1
		rotation.y = 0
	
	# Process gravity
	velocity.y -= gravity * delta
	
	# Normalize movement
	movement *= speed * delta
	velocity.x = movement.x
	velocity.z = movement.y
	
	move_and_slide()
