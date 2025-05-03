extends Node2D


@onready var playButt = $playButton
@onready var settingsButt = $settingsButton
@onready var gunSight = $mouseGraphic
@onready var backgroundMusic = $backgroundMusic
@onready var gun = $gun
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	backgroundMusic.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	gunSight.global_position = get_viewport().get_mouse_position()
	if Input.is_action_pressed("click") and gun.playing == false:
		gun.play()
	if backgroundMusic.playing == false:
		backgroundMusic.play()


func _onPlayButtonUp() -> void:
	#we want to launch the game 
	get_tree().change_scene_to_file("res://gameScreen/startScene.tscn")
