extends Node2D

@onready var bottle = $Bottle
@onready var sprite =$Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#bottle.changeSprite(sprite)
	bottle.changeType(Globals.BottleType.BOMB)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func isEmitting() -> bool:
	return bottle.isEmitting()
func throw(d1, d2):
	bottle.throw(d1,d2)
	
func playSound() -> void:
	bottle.playSound()
	
func hideSprite() -> void:
	bottle.hideSprite()
	
func getType() -> Globals.BottleType:
	return Globals.BottleType.BOMB
	
func getBody() -> RigidBody2D:
	return bottle.getBody()
	
func isVisible () -> bool:
	return bottle.isVisible()
