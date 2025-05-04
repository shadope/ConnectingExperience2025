extends Node2D

@onready var bottle = $Bottle
@onready var sprite = $Sprite2D
#@onready var sprite = preload("res://gameObjects/throwables/assets/droppable.png")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#bottle.changeSprite(sprite)
	bottle.changeType(Globals.BottleType.DROP)
	bottle.addFriction(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#bottle.changeSprite(sprite)
	pass
	
func isEmitting() -> bool:
	return bottle.isEmitting()
func playSound() -> void:
	bottle.playSound()
func hideSprite() -> void:
	bottle.hideSprite()
	
func getType() -> Globals.BottleType:
	return Globals.BottleType.DROP
	
func getBody() -> RigidBody2D:
	return bottle.getBody()
func isVisible () -> bool:
	return bottle.isVisible()
