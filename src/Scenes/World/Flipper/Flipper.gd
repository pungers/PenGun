extends RigidBody2D

var activated = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#if activated:
	#	rotation = lerp(1.0 * rotation, PI / 2, delta * 25)
	#	if round(rotation * 100) == round(PI / 2 * 100):
	#		activated = false
	#else:
	#	rotation = lerp(1.0 * rotation, 0.0, delta * 5)
	pass

func _physics_process(delta):
	pass
func _on_timer_timeout():
	activated = true
	pass # Replace with function body.
