extends Panel

class_name HealthBar

@onready var foreground: ColorRect = $Foreground

var health: float = 10.0

func _process(delta):
	var ratio = health / 10.0
	foreground.scale.x = lerpf(foreground.scale.x, ratio, delta * 5)
	foreground.color.g = lerpf(foreground.color.g, ratio, delta * 5)
	foreground.color.r = lerpf(foreground.color.r, 1 - ratio, delta * 5)
	
func _on_health_updated(new_health):
	health = new_health
