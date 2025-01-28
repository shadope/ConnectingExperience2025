extends Node2D

var gravity = 1
@onready var rigidBody = $RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#we want to check if we were clicked by the user. 
	pass
	
func throw(d1, d2):
	rigidBody.throw(d1,d2)
