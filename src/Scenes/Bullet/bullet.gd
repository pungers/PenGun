extends Hitbox
var direction

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_translate(direction * delta)
	pass


func _on_area_2d_body_entered(_body: PhysicsBody2D):
	queue_free()
	pass # Replace with function body.
