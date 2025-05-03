extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused =false
	print("made it to canyon scene")
	Dialogic.start('endScene')
	Dialogic.timeline_ended.connect(_onEnd)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _onEnd() -> void:
	Globals.curLevel = Globals.levels.START
	get_tree().change_scene_to_file("res://gameScreen/mainMenu.tscn")	
