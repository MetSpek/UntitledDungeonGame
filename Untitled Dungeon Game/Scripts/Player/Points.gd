extends Control


onready var label = $Label

func _process(delta):
	label.text = str(GameController.achieved_points) + "/" + str(GameController.max_points)
