extends Node2D

var activated = false
var pos
# Called when the node enters the scene tree for the first time.
func _ready():
	pos = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#position = pos
	if activated:
		rotation = lerp(1.0 * rotation, PI / 2, delta)
		if round(rotation * 100) == round(PI / 2 * 100):
			activated = false
	else:
		rotation = lerp(1.0 * rotation, 0.0, delta * 5)
	pass

func _physics_process(delta):
	#var collisionInfo = $CharacterBody2D.move_and_collide(Vector2(0,0))
	#if collisionInfo:
	#	print("hi")
	pass

func _on_timer_timeout():
	activated = true
	pass # Replace with function body.
