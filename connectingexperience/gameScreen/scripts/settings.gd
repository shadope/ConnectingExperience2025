extends Node2D

var sound = AudioServer.get_bus_index("Master")
var busIndex
@onready var groupPair = { $sliders/gameSlider : "projSound",
	$sliders/musicSlider : "Master"
}

@onready var easyCheck = $HBoxContainer/Easy
@onready var mediumCheck = $HBoxContainer/medium
@onready var hardCheck = $HBoxContainer/hard
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for slider in $sliders.get_children():
		slider.connect("value_changed",_onDragEnd.bind(slider))
		slider.max_value = 1.0
		slider.step = 0.05
		var curVolGroup = groupPair[slider]
		busIndex = AudioServer.get_bus_index(curVolGroup)
		slider.value = db_to_linear(AudioServer.get_bus_volume_db(busIndex))
		
	if Globals.curDiff == Globals.diff.EASY:
		easyCheck.button_pressed = true
	if Globals.curDiff == Globals.diff.MED:
		mediumCheck.button_pressed = true
	if Globals.curDiff == Globals.diff.HARD:
		hardCheck.button_pressed = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _onDragEnd(value, slider) -> void:
	var soundGroup = groupPair[slider]
	busIndex = AudioServer.get_bus_index(soundGroup)
	AudioServer.set_bus_volume_db(busIndex, linear_to_db(value))


func buttonUp() -> void:
	mediumCheck.button_pressed = false
	hardCheck.button_pressed = false
	Globals.curDiff = Globals.diff.EASY
	Globals.changeDif()
	

func mediumButtonUp() -> void:
	easyCheck.button_pressed = false
	hardCheck.button_pressed = false
	Globals.curDiff = Globals.diff.MED
	Globals.changeDif()

func hardButtonUp() -> void:
	easyCheck.button_pressed = false
	mediumCheck.button_pressed = false
	Globals.curDiff = Globals.diff.HARD
	Globals.changeDif()


func _onBackButtonUP() -> void:
	get_tree().change_scene_to_file("res://gameScreen/mainMenu.tscn")
