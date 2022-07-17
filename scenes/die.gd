extends RigidBody

var rng = RandomNumberGenerator.new()
var locked = false

func _ready():
	rng.randomize()
	reroll()

func tell_rotation():
	return (self.rotation_degrees)

func reroll():
	var torque = Vector3(rng.randf_range(-4, 4), rng.randf_range(-4, 4), rng.randf_range(-4, 4))
	apply_central_impulse(Vector3(0, 10, 0))
	apply_torque_impulse(torque)
