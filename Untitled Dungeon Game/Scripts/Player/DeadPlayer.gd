extends RigidBody

var rng = RandomNumberGenerator.new()

func die():
	print(rotation)
	rng.randomize()
	apply_impulse(transform.basis.z, -transform.basis.z * 10)
	
	apply_torque_impulse(Vector3(rng.randi_range(3,-.3),0,0))
