extends Node2D

var gravity = 1
@onready var rigidBody = $RigidBody2D
@onready var area2D = $RigidBody2D/Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area2D.connect("input_event", _onInputEvent.bind())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#we want to check if we were clicked by the user. 
	pass
	
func throw(d1, d2):
	rigidBody.throw(d1,d2)



func _onInputEvent(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		print("click regersteri")
		get_tree().current_scene.bottleHit(self)
	#explode later lol
