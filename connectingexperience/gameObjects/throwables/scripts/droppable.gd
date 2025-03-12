extends Node2D

@onready var bottle = $Bottle
@onready var sprite = preload("res://gameObjects/throwables/assets/droppable.png")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bottle.changeSprite(load("res://gameObjects/throwables/assets/droppable.png"))
	bottle.changeType(Globals.BottleType.DROP)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
