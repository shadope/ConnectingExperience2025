extends Node2D
#signals
signal gameOver
signal gameWin
signal playHitSound
signal projOOB
#packedScenes
@export var tempBottle : PackedScene
@export var bomb : PackedScene
@export var droppable : PackedScene
@export var gameOverScreen : PackedScene
@export var gameWinScreen : PackedScene 

#throwable sounds
@onready var bottleSound = preload("res://sounds/throwableSounds/bottleExplode.wav")
@onready var bugSound = preload("res://sounds/throwableSounds/bugSquish.wav")
@onready var bombSound = preload("res://sounds/throwableSounds/bombExplode.wav")
#misc sounds
@onready var gunshot = preload("res://sounds/miscNoise/gunShot.wav")



#children
@onready var timer = $Timer
@onready var bottles = $bottles
@onready var bombs = $bombs
@onready var healthUI = $HealthUi
@onready var bar = $ProgressBar
@onready var background = $background
@onready var gunSight = $mouseGraphic
@onready var audioPlayer = $AudioStreamPlayer2D
@onready var gun = $playerSound
#window is by default 1920/
#TODO add in globals and make these a global
var sides = ["bottom", "left", "right"]
var viewportSize
var time = 0
var throwImages = []
var totBottles = 0
var spawnDelta = 0.0
@onready var maxBottles = Globals.diffMapping[Globals.curLevel]
@onready var throwImageMap = {}
@onready var screenCenter = get_viewport().get_visible_rect().size / 2

#sound mapping
@onready var throwSoundMap = {	Globals.BottleType.SHATTER : bottleSound,
								Globals.BottleType.DROP : bugSound,
								Globals.BottleType.BOMB : bombSound
	
}

#partilce mapping
@onready var parMapping = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#TODO set the sprites here lol 
	totBottles = 0
	background.texture = Globals.getBackground()
	#set throwable images
	throwImages = Globals.getThrowableImageList()
	throwImageMap = {Globals.BottleType.SHATTER : throwImages[0], 
					Globals.BottleType.DROP : throwImages[1],
					Globals.BottleType.BOMB : throwImages[2]}	
	viewportSize = get_viewport_rect().size
	timer.wait_time = 2.0
	timer.start()
	
	gameOver.connect(_onGameOver)
	gameWin.connect(_onGameWin)
	playHitSound.connect(_onPlayHitSound)
	projOOB.connect(_onProjOOB)
	
	#make particl colors
	parMapping[[Globals.levels.START, Globals.BottleType.SHATTER]] = make_gradient(Color(0.38, 0.24, 0.12), Color(0.53, 0.81, 0.98))
	parMapping[[Globals.levels.START, Globals.BottleType.DROP]]    = make_gradient(Color(0.55, 0.05, 0.05), Color(0.53, 0.81, 0.98))
	parMapping[[Globals.levels.START, Globals.BottleType.BOMB]]    = make_gradient(Color(1.0, 0.0, 0.0),     Color(0.53, 0.81, 0.98))
	parMapping[[Globals.levels.CAVE,  Globals.BottleType.SHATTER]] = make_gradient(Color(0.8, 0.8, 0.8),     Color(0.2, 0.2, 0.2))
	parMapping[[Globals.levels.CAVE,  Globals.BottleType.DROP]]    = make_gradient(Color(0.2, 0.3, 0.4),     Color(0.2, 0.2, 0.2))
	parMapping[[Globals.levels.CAVE,  Globals.BottleType.BOMB]]    = make_gradient(Color(1.0, 0.0, 0.0),     Color(0.2, 0.2, 0.2))
	parMapping[[Globals.levels.POWERLINE, Globals.BottleType.SHATTER]] = make_gradient(Color(1.0, 0.75, 0.0), Color(0.4, 0.0, 0.0))
	parMapping[[Globals.levels.POWERLINE, Globals.BottleType.DROP]]    = make_gradient(Color(0.8, 0.0, 0.0),   Color(0.4, 0.0, 0.0))
	parMapping[[Globals.levels.POWERLINE, Globals.BottleType.BOMB]]    = make_gradient(Color(1.0, 0.0, 0.0),   Color(0.4, 0.0, 0.0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	gunSight.global_position = get_viewport().get_mouse_position()
	if Input.is_action_pressed("click") and gun.playing == false:
		gun.play()
		
	var toSpawn = maxBottles - totBottles
	toSpawn = randi_range(0,toSpawn)
	spawnDelta+=delta
	if totBottles < maxBottles and spawnDelta > 1:
		spawnDelta = 0.0
		for i in range(0,toSpawn):
			spawnBottle()
		
		
	#what we want to do is spawn bottles randomly from the top 3 sides
	
func spawnBottle():
	#calculate a starting point for the bottle
	#for now lets just do it from the bottom
	var screenCenter = get_viewport().get_visible_rect().size / 2
	var sideVal = sides[randi_range(0,2)]
	var proj = chooseProjectile()
	totBottles+=1
	print("spawning proj! ", totBottles)
	if proj != droppable:
		spawnProj(proj)
	else:
		spawnDrop(proj)

				
func spawnProj(proj) -> void:
	var sideVal = sides[randi_range(0,2)]
	var center = viewportSize/2.0
	var bottleInst
	match sideVal:
		var x when x == "bottom":
			center.y = viewportSize.y
			#we want to randomize the x
			var minX = -center.x + center.x
			var maxX = center.x + center.x
			center.x = randi_range(minX, maxX)
			#lets just spawn it at the center for now
		var x when x == "left":
			#want to make it so the y is at the bottom
			center.x = viewportSize.x - viewportSize.x
			#we want to randomize the x
			var minY = -center.y + center.y
			var maxY = center.y + center.y
			center.y = randi_range(minY, maxY)
			#lets just spawn it at the center for now
		var x when x == "right":
			#want to make it so the y is at the bottom
			center.x = center.x + center.x
			#we want to randomize the x
			var minY = -center.y + center.y
			var maxY = center.y + center.y
			center.y = randi_range(minY, maxY)
			#lets just spawn it at the center for now
	bottleInst = proj.instantiate()
	bottles.add_child(bottleInst)
	bottleInst.global_position = center
	var centerDir = screenCenter - bottleInst.global_position
	bottleInst.throw(centerDir , 1000)

			
func spawnDrop(proj) -> void:
	var viewport_size = get_viewport().get_visible_rect().size

	# Random X across the full screen width
	var x_pos = randf_range(0, viewport_size.x)

	# Y position at the top of the screen (just above view if you want it to drop in)
	var y_pos = -70  # or -50 to spawn slightly offscreen

	var drop_inst = proj.instantiate()
	bottles.add_child(drop_inst)
	drop_inst.global_position = Vector2(x_pos, y_pos)

	
			

func chooseProjectile() -> PackedScene:
	var chance = randf()
	if chance > 0.8:
		return bomb
	elif chance > 0.4:
		return tempBottle
	else:
		return droppable
	
	#first narrow down what side it will come from
func bottleHit(bot) -> void:
	for bottle in bottles.get_children():
		if bot == bottle:
			#Delete
			bar.emit_signal("addProgress")
			bottle.hideSprite()
			totBottles-=1
			print("getting rid of bottle from hit, ", totBottles)
			#bottle.queue_free()
			
func bombHit(bom) -> void:
	for bomb in bottles.get_children():
		if bom == bomb:
			bomb.hideSprite()
			#bomb.queue_free()
			totBottles-=1
			healthUI.emit_signal("damageTaken")
			#and then detrimate health
			
func _onGameOver():
	get_tree().paused = true
	var goScreen = gameOverScreen.instantiate()
	goScreen.process_mode = Node.PROCESS_MODE_ALWAYS
	self.add_child(goScreen)
	pass
	
func _onGameWin():
	get_tree().paused = true
	var winScreen = gameWinScreen.instantiate()
	winScreen.process_mode = Node.PROCESS_MODE_ALWAYS
	self.add_child(winScreen)
	
func _onPlayHitSound(throwType : Globals.BottleType) -> void:
	audioPlayer.stream = throwSoundMap[throwType]
	audioPlayer.play()
	
func deleteProj(projectile):
	for proj in bottles.get_children():
		if proj == projectile:
			proj.queue_free()
	
func make_gradient(color1: Color, color2: Color) -> ParticleProcessMaterial:
	var mat := ParticleProcessMaterial.new()
	mat.color = color1
	return mat
	
func getGradientMapping(bottleType):
	return parMapping[[Globals.curLevel, bottleType]]
	
func returnScreenBound(projCoords) -> bool:
	var screen_size = get_viewport().size
	var screen_rect = Rect2(Vector2(0, 0), screen_size)
	screen_rect = screen_rect.grow(20.0)
	return screen_rect.has_point(projCoords)
	
func _onProjOOB(projectile) -> void:
	pass
			
			


func _onAreaEntered(area: Area2D) -> void:
	pass # Replace with function body.


func _onBodyAreaEntered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	for proj in bottles.get_children():
		if proj.getBody() == body and proj.isVisible() and proj.getType() != Globals.BottleType.BOMB:
			#Delete
			healthUI.emit_signal("damageTaken")
			proj.queue_free()
			totBottles-=1
			print("getting rid of bottle by OOB", totBottles)
		elif proj.getType() == Globals.BottleType.BOMB and proj.isVisible():
			proj.queue_free()
			totBottles-=1
			print("getting rid of bomb by OOB", totBottles)
