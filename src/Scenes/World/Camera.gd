extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mousePos = get_viewport().get_mouse_position()
	# center mouse position
	mousePos.x -= get_viewport().size.x / 2
	mousePos.y -= get_viewport().size.y / 2
	global_position = get_parent().get_node("Player").global_position + mousePos * 0.1
	if zoom > Vector2(2, 2):
		zoom -= Vector2(delta * 3 * (zoom.x - 1), delta * 3 * (zoom.y - 1))
	elif zoom < Vector2(2,2):
		zoom = Vector2(2,2)
	pass


func _on_player_cam_zoom(newZoom):
	zoom = newZoom
	pass # Replace with function body.
