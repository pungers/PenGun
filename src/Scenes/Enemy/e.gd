extends Area2D

var bullet
var bulletList = []

var count
var d = {0: Vector2(1, 0),
		1: Vector2(0, 1),
		2: Vector2(-1, 0),
		3: Vector2(0, -1)}

# Called when the node enters the scene tree for the first time.
func _ready():
	bullet = preload("res://Scenes/Bullet/bullet.tscn")
	count = 0
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	var current = bullet.instantiate()
	add_child(current)
	current.direction = d[count]
	count = (count + 1) % 4
	
	pass # Replace with function body.
