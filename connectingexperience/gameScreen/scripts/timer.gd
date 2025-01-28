extends Timer

signal spawnBottle
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("butt")
	timeout.connect(_onSpawnBottle)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _onSpawnBottle():
	print("making it to timer spawn ")
	get_parent().spawnBottle()
