extends Node2D
#signals
signal gameOver
signal gameWin
signal playHitSound
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
@onready var particles = $CPUParticles2D
#window is by default 1920/
#TODO add in globals and make these a global
var maxBottles = 10
var sides = ["bottom", "left", "right"]
var viewportSize
var time = 0
var throwImages = []
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
	background.texture = Globals.getBackground()
	#set throwable images
	throwImages = Globals.getThrowableImageList()
	throwImageMap = {Globals.BottleType.SHATTER : throwImages[0], 
					Globals.BottleType.DROP : throwImages[1],
					Globals.BottleType.BOMB : throwImages[2]}
	print("throw images: ", throwImages)	
	viewportSize = get_viewport_rect().size
	timer.wait_time = 2.0
	timer.start()
	
	gameOver.connect(_onGameOver)
	gameWin.connect(_onGameWin)
	playHitSound.connect(_onPlayHitSound)
	
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
		print("gun shot")
		gun.play()
		
	#what we want to do is spawn bottles randomly from the top 3 sides
	
func spawnBottle():
	#calculate a starting point for the bottle
	#for now lets just do it from the bottom
	var screenCenter = get_viewport().get_visible_rect().size / 2
	var sideVal = sides[randi_range(0,2)]
	var proj = chooseProjectile()
	
	
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
			#we want to spawn from the bottom of the screen, meaning we have to generate a value
			#randomly within those fields, y does not chaneg, x does'
			#want to make it so the y is at the bottom
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
	print("center dir: ", centerDir)
	bottleInst.throw(centerDir , 1000)

			
func spawnDrop(proj) -> void:
	var screenCenter = get_viewport().get_visible_rect().size / 2
	var center = viewportSize/2.0
	#want to make it so the y is at the bottom
	center.y = -viewportSize.y
	#we want to randomize the x
	var minX = -center.x + center.x
	var maxX = center.x + center.x
	center.x = randi_range(minX, maxX)
	var dropInst = proj.instantiate()
	#set to current image
	bottles.add_child(dropInst)
	dropInst.global_position = center
	
			

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
			print("in delete")
			bar.emit_signal("addProgress")
			bottle.hideSprite()
			#bottle.queue_free()
			
func bombHit(bom) -> void:
	for bomb in bottles.get_children():
		if bom == bomb:
			print("deleting bomb")
			bomb.hideSprite()
			#bomb.queue_free()
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
	print("audio stream: ", audioPlayer.stream)
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
	print("type: ", bottleType, "lvel: ", Globals.curLevel)
	print("mapping: ", parMapping)
	return parMapping[[Globals.curLevel, bottleType]]
			
			
