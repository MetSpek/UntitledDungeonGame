extends Spatial

export var size = 500
export var points_amount = 20

var next_point = ["Front", Vector3(0,0,0)]

var rng = RandomNumberGenerator.new()

var available_directions : Array
var available_coordinates : Array

var unavailable_coordinates : Array

var point = load("res://Scenes/World/Point.tscn")

func _ready():
	makeMaze(size)

func makeMaze(size):
	print("start making the maze")
	available_coordinates.append(next_point[1])
	available_directions.append(next_point[0])
	for x in range(10):
		for y in range(size / 10):
			createPieces()
		yield(get_tree().create_timer(.1), "timeout")
	closeMaze()
	spawnPoints()

func createPieces():
	if available_coordinates.size() > 0:
			addPiece(next_point, chooseNextPiece(next_point))
			available_coordinates.remove(0)
			available_directions.remove(0)
			next_point = [available_directions[0], available_coordinates[0]]
	else:
		return

func chooseNextPiece(point):
	rng.randomize()
	var randomPiece
	match point[0]:
		"Front":
			randomPiece = AllPaths.front_paths[rng.randi_range(0, AllPaths.front_paths.size() - 1)]
		"Left":
			randomPiece = AllPaths.left_paths[rng.randi_range(0, AllPaths.left_paths.size() - 1)]
		"Right":
			randomPiece = AllPaths.right_paths[rng.randi_range(0, AllPaths.right_paths.size() - 1)]
		"Back":
			randomPiece = AllPaths.back_paths[rng.randi_range(0, AllPaths.back_paths.size() - 1)]
	return randomPiece

func addPiece(point, piece):
	unavailable_coordinates.append(point[1])
	var new_piece = piece.instance()
	new_piece.translation = point[1]
	self.add_child(new_piece)
	addConnections(new_piece)

func addConnections(piece):
	for x in piece.get_child(0).connections:
		if unavailable_coordinates.find(x[1] + next_point[1]) == -1:
			if available_coordinates.find(x[1] + next_point[1]) == -1:
				available_coordinates.append(x[1] + next_point[1])
				available_directions.append(x[0])

func closeMaze():
	for x in available_coordinates:
		var new_close = AllPaths.iiii.instance()
		new_close.translation = x
		get_child(0).get_child(0).add_child(new_close)

func spawnPoints():
	print("Planting all powerups")
	GameController.max_points = points_amount
	for x in range(points_amount):
		var new_point = point.instance()
		new_point.translation = new_point.translation + getRandomPointInMaze()
		self.add_child(new_point)

func getRandomPointInMaze():
	rng.randomize()
	var coordinate = unavailable_coordinates[rng.randi_range(0, unavailable_coordinates.size() - 1)]
	unavailable_coordinates.remove(rng.randi_range(0, unavailable_coordinates.size() - 1))
	return coordinate

func _physics_process(delta):
	if Input.is_action_just_pressed("reset_maze"):
		resetMaze()

func resetMaze():
	for x in range(get_child_count()):
		self.get_child(x).queue_free()
	available_coordinates.clear()
	available_directions.clear()
	unavailable_coordinates.clear()
	next_point = ["Front", Vector3(0,0,0)]
	makeMaze(size)
