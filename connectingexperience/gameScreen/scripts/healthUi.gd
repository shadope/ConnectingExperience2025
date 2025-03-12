extends Node2D
signal damageTaken

@onready var curBullets = $Panel/HBoxContainer.get_children()
var curIndex = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damageTaken.connect(_onDamageTaken)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _onDamageTaken() -> void:
	if curIndex == 0:
		get_tree().current_scene.emit_signal("gameOver")
	var curBullet = curBullets[curIndex]
	curBullet.self_modulate = Color(1, 1, 1, 0.5)
	curIndex-=1
