extends Node2D

var gravity = 1
@onready var rigidBody = $RigidBody2D
@onready var area2D = $RigidBody2D/Area2D
@onready var sprite = $RigidBody2D/Sprite2D
@onready var collShape = $RigidBody2D/Area2D/CollisionShape2D


#default
var currentBottle: Globals.BottleType = Globals.BottleType.SHATTER

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
		if currentBottle == Globals.BottleType.SHATTER or currentBottle == Globals.BottleType.DROP:
			get_tree().current_scene.bottleHit(self)
		if currentBottle == Globals.BottleType.BOMB:
			print("hitting bomb")
			get_tree().current_scene.bombHit(self.get_parent())
	#explode later lol
	
func changeSprite(newSprite):
	sprite.texture = newSprite
	sprite.scale = Vector2(0.195, 0.228)
	
	
	
func changeType(newType):
	currentBottle = newType
	if newType == Globals.BottleType.DROP:
		sprite.rotation_degrees = 180
		sprite.scale = Vector2(0.234, 0.208)

func addAirRes(newVal) -> void:
	rigidBody.linear_damp = newVal
	
