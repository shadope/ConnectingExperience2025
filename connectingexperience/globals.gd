extends Node

#preload stuff yayay

@onready var lev1Background = preload("res://gameScreen/assets/s1Background.png")
@onready var lev2Background = preload("res://gameScreen/assets/s2Background.png")
@onready var lev3Background = preload("res://gameScreen/assets/s3Background.png")



#level 1 throwable images
@onready var lev1Bottle = preload("res://gameScreen/assets/screenParts/bottleBasic.webp")
@onready var lev1Droppable = preload("res://gameObjects/throwables/assets/droppable.png")
@onready var lev1Bomb = preload("res://gameObjects/throwables/assets/bomb.png")
#level 2 throwable images
@onready var lev2Bottle = preload("res://gameObjects/throwables/assets/Can.webp")
@onready var lev2Droppable = preload("res://gameObjects/throwables/assets/Mushroom.png")
@onready var lev2Bomb = preload("res://gameObjects/throwables/assets/bomb.png")
#level 3 throwable images
@onready var lev3Bottle = preload("res://gameObjects/throwables/assets/potion.png")
@onready var lev3Droppable = preload("res://gameObjects/throwables/assets/Lizard.png")
@onready var lev3Bomb = preload("res://gameObjects/throwables/assets/bomb.png")


#TODO make sound mappings



enum BottleType { SHATTER, BOMB, DROP }
enum levels {START, CAVE, POWERLINE, END}
var curLevel = levels.START
@onready var backgroundMap = {levels.START : lev1Background, levels.CAVE : lev2Background, levels.POWERLINE : lev3Background}
#mappings to throwable images per levelle
@onready var throwImageMap = { levels.START : [lev1Bottle, lev1Droppable, lev1Bomb],
							   levels.CAVE : [lev2Bottle, lev2Droppable, lev2Bomb],
							   levels.POWERLINE : [lev3Bottle, lev3Droppable, lev3Bomb]
}
@onready var diffMapping = {levels.START : 4, levels.CAVE : 3, levels.POWERLINE : 4}
@onready var barMapping = {levels.START : 10, levels.CAVE : 30, levels.POWERLINE : 40}

#scene packs aya
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func getBackground() -> Texture2D:
	return backgroundMap[curLevel]
	#set the background based on what level we are on yayayay
	
	
func getThrowableImageList() -> Array:
	return throwImageMap[curLevel]
	
