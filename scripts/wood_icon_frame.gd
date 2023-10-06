extends Panel

class_name WoodIconFrame

@onready var fill: ColorRect = $Fill

var max: float = 5
var collected: float = 0

func _process(delta):
	var ratio: float = collected / max
	fill.scale.y = lerpf(fill.scale.y, ratio, delta * 5.0)
	fill.color.r = lerpf(fill.color.r, 1 - ratio, delta * 5.0)

func _on_wood_collected():
	collected += 1
