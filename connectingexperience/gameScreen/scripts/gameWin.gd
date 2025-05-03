extends Node2D

@export var startScene : PackedScene
@export var canyonScene : PackedScene
@export var powerlineScene : PackedScene
@export var endScene : PackedScene
@export var mainMenu : PackedScene

@onready var sceneMap = {Globals.levels.START : canyonScene, 
						 Globals.levels.CAVE : powerlineScene,
 						 Globals.levels.POWERLINE : endScene,
						 Globals.levels.END : endScene}
				
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#this is for continue, minsanmed and I am laze
func pressed() -> void:
	#want to launch the next scene
	print("cont pressed")
	#change it to next scene
	var nextScene = sceneMap[Globals.curLevel]
	print("nextScnen", nextScene)
	get_tree().change_scene_to_packed(nextScene)


func menuPressed() -> void:
	mainMenu = load("res://gameScreen/mainMenu.tscn")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://gameScreen/mainMenu.tscn")
	pass # Replace with function body.
