extends CharacterBody3D

class_name Shark

const patrol_speed: float = 300
const chase_speed: float = 600
const rot_speed: float = 5

enum Status {
	PATROL,
	CHASE,
	ATTACK
}

@export var nav_zone: Node3D

@onready var status: Status = Status.PATROL
@onready var waypoints = nav_zone.get_children()
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var bite_timer: Timer = $AttackTimer

var wp: int = 0
var player: Player

func _physics_process(delta):
	var direction: Vector3 = Vector3.ZERO
	var advance: float = 0
	var target_pos: Vector3 = Vector3.ZERO
	
	if player == null or player.dead:
		status = Status.PATROL
	
	match status:
		Status.PATROL:
			target_pos = waypoints[wp].global_position
			var dist = global_position.distance_to(target_pos)
			if dist < 1:
				wp += 1
			if wp >= len(waypoints):
				wp = 0
			advance = patrol_speed * delta
			if player != null and player.in_water:
				status = Status.CHASE
			
		Status.CHASE:
			target_pos = player.position
			var dist = global_position.distance_to(target_pos)
			advance = chase_speed * delta
			if not player.in_water or player.dead:
				status = Status.PATROL
			elif dist < 2:
				status = Status.ATTACK
				anim.play("Attack")
				bite_timer.start()
				
		Status.ATTACK:
			target_pos = player.position
			var dist = global_position.distance_to(target_pos)
			if dist > 2 or player.dead:
				if player.dead:
					status = Status.PATROL
				else:
					status = Status.CHASE
				bite_timer.stop()
				anim.play("Swim")
	
	var old_rot = rotation
	look_at(transform.origin - velocity, Vector3.UP)
	rotation = lerp(old_rot, rotation, delta * rot_speed)
	direction = global_position.direction_to(target_pos)
	
	velocity = direction * advance
	move_and_slide()

func _on_player_detected(body):
	player = body as Player
	if status == Status.PATROL and player.in_water and not player.dead:
		status = Status.CHASE
	
func _on_player_lost(_body):
	player = null
	if not bite_timer.is_stopped():
		bite_timer.stop()
	if status != Status.PATROL:
		status = Status.PATROL
		anim.play("Swim")

func _on_bite():
	if player != null and not player.dead:
		player.take_bite()