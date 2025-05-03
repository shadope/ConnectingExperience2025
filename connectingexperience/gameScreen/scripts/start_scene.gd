extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.start('startScene')
	Dialogic.timeline_ended.connect(_onEnd)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _onEnd() -> void:
	get_tree().change_scene_to_file("res://gameScreen/game_screen.tscn")	
