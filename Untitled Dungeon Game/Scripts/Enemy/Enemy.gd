extends KinematicBody

enum {
	SEARCHING,
	LASTLOC,
	FOLLOWING,
	RUNNING
}

var rng = RandomNumberGenerator.new()

var player
var last_know_location
var place

export var SPEED = 3
export var FOLLOW_SPEED = 1
export var FOLLOW_ACCEL = 0.01

var state = SEARCHING
onready var raycast = $RayCast
onready var los = $Los

func _ready():
	player = get_node("/root").find_node("Player", true, false)

func _physics_process(delta):
	if state == SEARCHING:
		searchHunt()
		if check_los():
			state = FOLLOWING
	elif state == FOLLOWING:
		followHunt()
		if not check_los():
			state = LASTLOC
	elif state == LASTLOC:
		if $WaitTimer.wait_time <= 0:
			place = player.global_translation
			$WaitTimer.start()
			print(place)
		lastLocHunt(place)
	

func searchHunt():
	if not raycast.is_colliding():
		move_and_slide(-transform.basis.z * SPEED, Vector3.UP, true)
	else:
		rotation_degrees.y += getNewDir()

func followHunt():
	var velocity = global_transform.origin.direction_to(player.global_transform.origin)
	move_and_slide(velocity * FOLLOW_SPEED, Vector3.UP)
	FOLLOW_SPEED += FOLLOW_ACCEL

func lastLocHunt(place):
	print(place)
	var velocity = global_transform.origin.direction_to(player.global_transform.origin)
	move_and_slide(velocity * SPEED, Vector3.UP)

func getNewDir():
	rng.randomize()
	var random_number = rng.randi_range(0,2)
	match random_number:
		0: 
			return 90
		1:
			return -90
		2:
			return 180

func check_los():
	los.look_at_from_position(global_transform.origin, player.global_transform.origin, Vector3.UP)
	if los.is_colliding():
		if los.get_collider().name == "Player":
			return true


func _on_Hitbox_body_entered(body):
	if body.has_method("die"):
		body.die()


func _on_WaitTimer_timeout():
	print("dsofi")
	state = SEARCHING
