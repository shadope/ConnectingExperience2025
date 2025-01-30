extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var rotateVal =randf_range(0,1)
	self.apply_impulse(Vector2(0,-5).rotated(rotateVal), Vector2(0,15))
	pass


func throw(direction:Vector2, strength:float) -> void:
	print("thrwoing")
	var force = direction.normalized() * strength
	self.apply_central_impulse(force)
	
	var rotateVal =randf_range(0,1)
	self.apply_impulse(Vector2(0,-5).rotated(rotateVal), Vector2(0,15))
	#add drag and make the tip more dense
