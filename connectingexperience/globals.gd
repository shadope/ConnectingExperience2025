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

#level 1 bar over/under
@onready var lev1BarBase = preload("res://gameScreen/assets/screenParts/startBarbase.png")
@onready var lev1BarLoad = preload("res://gameScreen/assets/screenParts/level2BarBase.png")
#level 2 bar over/under
@onready var lev2BarBase = preload("res://gameScreen/assets/screenParts/level2BarBase.png")
@onready var lev2BarLoad = preload("res://gameScreen/assets/screenParts/caveBarBase.png")
#level 3 bar over/under
@onready var lev3BarBase = preload("res://gameScreen/assets/screenParts/caveBarBase.png")
@onready var lev3BarLoad = preload("res://gameScreen/assets/screenParts/powerlineBarBase.png")

#bar maps
@onready var barImageMap = { levels.START : [lev1BarBase, lev1BarLoad],
					levels.CAVE : [lev2BarBase, lev2BarLoad],
					levels.POWERLINE : [lev3BarBase, lev3BarLoad]
}

#TODO make sound mappings



enum BottleType { SHATTER, BOMB, DROP }
enum levels {START, CAVE, POWERLINE, END}
var curLevel = levels.START
enum diff {EASY, MED, HARD}
var curDiff = diff.MED

@onready var backgroundMap = {levels.START : lev1Background, levels.CAVE : lev2Background, levels.POWERLINE : lev3Background}
#mappings to throwable images per levelle
@onready var throwImageMap = { levels.START : [lev1Bottle, lev1Droppable, lev1Bomb],
							   levels.CAVE : [lev2Bottle, lev2Droppable, lev2Bomb],
							   levels.POWERLINE : [lev3Bottle, lev3Droppable, lev3Bomb]
}
@onready var diffMapping = {levels.START : 2, levels.CAVE : 3, levels.POWERLINE : 4}
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
	
func changeDif() -> void:
	match Globals.curDiff:
		diff.EASY:
			diffMapping = {levels.START : 1, levels.CAVE : 2, levels.POWERLINE : 2}
			barMapping = {levels.START : 10, levels.CAVE : 10, levels.POWERLINE : 20}
		diff.MED:
			diffMapping = {levels.START : 2, levels.CAVE : 3, levels.POWERLINE : 3}
			barMapping = {levels.START : 10, levels.CAVE : 20, levels.POWERLINE : 30}
		diff.HARD:
			diffMapping = {levels.START : 2, levels.CAVE : 3, levels.POWERLINE : 4}
			barMapping = {levels.START : 20, levels.CAVE : 30, levels.POWERLINE : 40}
