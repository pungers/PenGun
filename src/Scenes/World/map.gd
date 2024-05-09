extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	# for testing purposes
	
	if Input.is_action_pressed("move_up"):

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_T:
			print("T was pressed")
			
			Engine.max_fps = 100
			
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_T:
			print("T was pressed")
			
			Engine.max_fps = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
