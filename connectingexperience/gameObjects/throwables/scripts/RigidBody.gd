extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass


func throw(direction: Vector2, strength: float) -> void:
	print("throwing")
	
	# Apply forward force
	var force = direction.normalized() * strength
	self.apply_central_impulse(force)
	
	# Apply rotational impulse for spin
	var rotate_val = randf_range(-1, 1)  # Allows spin in both directions
	var spin_force = Vector2(0, -50).rotated(rotate_val)  # Stronger rotation force
	var offset = Vector2(20, 15)  # Offset to create rotation

	self.apply_impulse(spin_force, offset)
	
	# Reduce air resistance for a natural spin
	self.linear_damp = 0.1
	self.angular_damp = 0.05

	# Shift center of mass to tip to enhance rotation effect
	self.center_of_mass = Vector2(0, 10)
