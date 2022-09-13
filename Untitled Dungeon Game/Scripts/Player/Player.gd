extends KinematicBody

enum {
	ALIVE,
	DEAD
}

var player_body = load("res://Scenes/Player/DeadPlayer.tscn")

onready var camera = $Pivot/Camera

var gravity = -30
var max_speed = 8
var mouse_sensitivity = 0.002  # radians/pixel

var velocity = Vector3()

var player_state = ALIVE


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func get_input():
	
	var input_dir = Vector3()
	# desired move in camera direction
	if Input.is_action_pressed("move_forward"):
		input_dir += -global_transform.basis.z
	if Input.is_action_pressed("move_backward"):
		input_dir += global_transform.basis.z
	if Input.is_action_pressed("move_left"):
		input_dir += -global_transform.basis.x
	if Input.is_action_pressed("move_right"):
		input_dir += global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)

func _physics_process(delta):
	if Input.is_action_just_pressed("player_die"):
		player_state == DEAD
		die()
	
	if player_state == ALIVE:
		velocity.y += gravity * delta
		var desired_velocity = get_input() * max_speed

		velocity.x = desired_velocity.x
		velocity.z = desired_velocity.z
		velocity = move_and_slide(velocity, Vector3.UP, true)

func die():
	player_state == DEAD
	var dead_player = player_body.instance()
	dead_player.global_translation = global_translation
	dead_player.rotation_degrees = rotation_degrees
	get_tree().get_root().add_child(dead_player)
	dead_player.die()
	
