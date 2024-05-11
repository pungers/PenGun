extends Node2D
signal slidingTimerSignal

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_R:
			print("r was pressed")
			
			Engine.max_fps = 3
			
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_T:
			print("T was pressed")
			
			Engine.max_fps = 60
			
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_Y:
			print("y was pressed")
			Engine.max_fps += 1
			
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_U:
			print("y was pressed")
			Engine.max_fps -= 1

func _on_player_sliding_timer_signal(slidingTimer):
	emit_signal("slidingTimerSignal", slidingTimer)
	pass # Replace with function body.
