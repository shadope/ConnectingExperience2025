extends Node2D

@export var startScene : PackedScene
@export var canyonScene : PackedScene
@export var powerlineScene : PackedScene
@export var endScene : PackedScene
@export var mainMenu : PackedScene


@onready var sceneMap = {Globals.levels.START : startScene, 
						 Globals.levels.CAVE : canyonScene,
 						 Globals.levels.POWERLINE : powerlineScene,
						 Globals.levels.END : endScene}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _onTryAgainButtonUp() -> void:
	print("cont pressed")
	#change it to next scene
	var nextScene = sceneMap[Globals.curLevel]
	print("nextScnen", nextScene)
	get_tree().paused = false
	get_tree().reload_current_scene()



func _onMainMenuButtonUp() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://gameScreen/mainMenu.tscn")
