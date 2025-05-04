extends Node2D

var gravity = 1
@onready var rigidBody = $RigidBody2D
@onready var area2D = $RigidBody2D/Area2D
@onready var sprite = $RigidBody2D/Sprite2D
@onready var collShape = $RigidBody2D/Area2D/CollisionShape2D
@onready var particles = $RigidBody2D/CPUParticles2D
@onready var audio = $AudioStreamPlayer2D

#sounds we can have
@onready var bottleSound = preload("res://sounds/throwableSounds/bottleExplode.wav")

var throwImages = []
@onready var throwImageMap = {}

#variables
var waitingSound = true
var audioPlayed = false



#default
var currentBottle: Globals.BottleType = Globals.BottleType.SHATTER

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area2D.connect("input_event", _onInputEvent.bind())
	throwImages = Globals.getThrowableImageList()
	throwImageMap = {Globals.BottleType.SHATTER : throwImages[0], 
					Globals.BottleType.DROP : throwImages[1],
					Globals.BottleType.BOMB : throwImages[2]}
	#set sprite
	var tempSprite = Sprite2D.new()
	tempSprite.texture = throwImageMap[currentBottle]
	changeSprite(tempSprite)
	particles.emitting = false
	#particles.one_shot = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#we want to check if we were clicked by the user.
	pass
	
func throw(d1, d2):
	rigidBody.throw(d1,d2)



func _onInputEvent(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		print("click regersteri")
		get_tree().current_scene.emit_signal("playHitSound",currentBottle )
		particles.emitting = true
		if currentBottle == Globals.BottleType.SHATTER:
			get_tree().current_scene.bottleHit(self)
		if currentBottle == Globals.BottleType.BOMB:
			print("hitting bomb")
			get_tree().current_scene.bombHit(self.get_parent())
		if currentBottle == Globals.BottleType.DROP:
			get_tree().current_scene.bottleHit(self.get_parent())
		#
	##explode later lol
	
func changeSprite(newSprite):
	var old_texture_size = sprite.texture.get_size()
	var old_scale = sprite.scale
	var new_texture_size = newSprite.texture.get_size()

	sprite.texture = newSprite.texture

	if old_texture_size != Vector2.ZERO and new_texture_size != Vector2.ZERO:
		# Compute total visual size before change
		var old_visual_size = old_texture_size * old_scale
		# Compute new scale needed to keep the visual size consistent
		sprite.scale = old_visual_size / new_texture_size
	
	
func changeType(newType):
	currentBottle = newType
	var tempSprite = Sprite2D.new()
	tempSprite.texture = throwImageMap[currentBottle]
	changeSprite(tempSprite)
	setPColor()
	if newType == Globals.BottleType.DROP:
		#maybe dont do this in level 3
		sprite.rotation_degrees = 180
		#sprite.scale = Vector2(0.234, 0.208)
		
func addFriction(val):
	rigidBody.linear_damp = val
	
#func changeImage(image) -> void:
	#print("imageL ", image, " sprite: ", sprite)
	#sprite.texture = image
	#changeSprite(sprite)
	
func getType() -> Globals.BottleType:
	return currentBottle

func playSound() -> void:
	audio.stream = bottleSound
	print("we are playing sound", audio.get_stream_playback())
	if audio.stream != null:	
		audio.play()
		audio.playing = true
		audioPlayed = true
		
func isEmitting() -> bool:
	return particles.emitting
	
func hideSprite() -> void:
	sprite.visible = false


func _OnParticlesDone() -> void:
	get_tree().current_scene.deleteProj(get_parent())
	
func setPColor():
	
	print("setting p color")
	var mat = get_tree().current_scene.getGradientMapping(currentBottle)
	print("mat color: ", mat.color)
	particles.color = mat.color
	#if mat.color_ramp and mat.color_ramp.gradient:
		#var grad = mat.color_ramp.gradient
		#var points = grad.get_point_count()
		#
		#if points >= 2:
			#var color1 = grad.get_color(0)
			#var color2 = grad.get_color(points - 1)
			#print("Gradient Colors -> Start: ", color1, ", End: ", color2)
		#else:
			#print("Gradient has fewer than 2 color points.")
	#else:
		#print("No gradient ramp found in material.")
	particles.material = mat
			
