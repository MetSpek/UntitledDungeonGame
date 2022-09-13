extends Node

var max_points = 0
var achieved_points = 0


var able_to_slay = false

func updateScore():
	achieved_points += 1
	if achieved_points >= max_points:
		able_to_slay = true
		print("READY TO SLAY")
