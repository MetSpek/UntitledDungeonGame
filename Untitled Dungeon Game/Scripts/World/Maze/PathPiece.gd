extends StaticBody

export var size : int
export var front : bool
export var left : bool
export var right : bool
export var back : bool
export var blocked_pieces : Array

var connections : Array

func _ready():
	if front:
		connections.append(["Front",Vector3(0,0,-size)])
	if left:
		connections.append(["Left",Vector3(-size,0,0)])
	if right:
		connections.append(["Right",Vector3(size,0,0)])
	if back:
		connections.append(["Back",Vector3(0,0,size)])
