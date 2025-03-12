extends Node2D

signal addProgress

@onready var bar = $TextureProgressBar

#default
var totBottles = 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	addProgress.connect(_onAddProgress)
	bar.max_value = totBottles
	bar.value = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func setTotBottles(num) -> void:
	totBottles = num
	bar.max_value = totBottles
	bar.value = 0
	
func _onAddProgress() -> void:
	bar.value += 1
	if bar.value >= bar.max_value:
		get_tree().current_scene.emit_signal("gameWin")
