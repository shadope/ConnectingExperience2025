extends Timer

signal spawnBottle
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timeout.connect(_onSpawnBottle)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _onSpawnBottle():
	get_parent().spawnBottle()
