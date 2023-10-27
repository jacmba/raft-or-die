extends Panel

class_name HungerBar

@onready var foreground: ColorRect = $Foreground

var hunger: float = 10.0

func _process(delta):
	var ratio = hunger / 10.0
	foreground.scale.x = lerpf(foreground.scale.x, ratio, delta * 5)
	foreground.color.g = lerpf(foreground.color.g, ratio, delta * 5)
	foreground.color.r = lerpf(foreground.color.r, 1 - ratio, delta * 5)
	
func _on_hunger_updated(new_hunger):
	hunger = new_hunger
