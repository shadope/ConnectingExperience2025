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
	if maxBottles > 0:
		var sideVal = sides[0]
		match sideVal:
			var x when x == "bottom":
				print("making it here")
				#we want to spawn from the bottom of the screen, meaning we have to generate a value
				#randomly within those fields, y does not chaneg, x does'
				var center = viewportSize/2.0
				#lets just spawn it at the center for now
				var bottleInst = tempBottle.instantiate()
				bottles.add_child(bottleInst)
				bottleInst.global_position = center
		maxBottles -= 1
			

			
			
			
	#first narrow down what side it will come from
	
