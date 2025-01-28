extends Node2D
#packedScenes
@export var tempBottle : PackedScene

#children
@onready var timer = $Timer
@onready var bottles = $bottles
#window is by default 1920/
#TODO add in globals and make these a global
var maxBottles = 10
var sides = ["bottom", "left", "right"]
var viewportSize
var time = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewportSize = get_viewport_rect().size
	timer.wait_time = 2.0
	timer.start()
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


	
	
	#what we want to do is spawn bottles randomly from the top 3 sides
	
func spawnBottle():
	#calculate a starting point for the bottle
	#for now lets just do it from the bottom
	var screenCenter = get_viewport().get_visible_rect().size / 2
	if maxBottles > 0:
		var sideVal = sides[randi_range(0,2)]
		match sideVal:
			var x when x == "bottom":
				#we want to spawn from the bottom of the screen, meaning we have to generate a value
				#randomly within those fields, y does not chaneg, x does'
				var center = viewportSize/2.0
				#want to make it so the y is at the bottom
				center.y = viewportSize.y
				#we want to randomize the x
				var minX = -center.x + center.x
				var maxX = center.x + center.x
				center.x = randi_range(minX, maxX)
				#lets just spawn it at the center for now
				var bottleInst = tempBottle.instantiate()
				bottles.add_child(bottleInst)
				bottleInst.global_position = center
				
				var centerDir  = screenCenter - bottleInst.global_position
				bottleInst.throw(centerDir , 1000)
			var x when x == "left":
				var center = viewportSize/2.0
				#want to make it so the y is at the bottom
				center.x = viewportSize.x - viewportSize.x
				#we want to randomize the x
				var minY = -center.y + center.y
				var maxY = center.y + center.y
				center.y = randi_range(minY, maxY)
				#lets just spawn it at the center for now
				var bottleInst = tempBottle.instantiate()
				bottles.add_child(bottleInst)
				bottleInst.global_position = center
				var centerDir  = screenCenter - bottleInst.global_position
				
				bottleInst.throw(centerDir , 1000)
			var x when x == "right":
				var center = viewportSize/2.0
				#want to make it so the y is at the bottom
				center.x = center.x + center.x
				#we want to randomize the x
				var minY = -center.y + center.y
				var maxY = center.y + center.y
				center.y = randi_range(minY, maxY)
				#lets just spawn it at the center for now
				var bottleInst = tempBottle.instantiate()
				bottles.add_child(bottleInst)
				bottleInst.global_position = center
				var centerDir = screenCenter - bottleInst.global_position
				
				bottleInst.throw(centerDir , 1000)
		maxBottles -= 0
			

			
			
			
	#first narrow down what side it will come from
func bottleHit(bot) -> void:
	print("hit bottle")
	for bottle in bottles.get_children():
		if bot == bottle:
			bottle.queue_free()
