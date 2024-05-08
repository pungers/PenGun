extends Node2D

@onready var bulletObj = preload("res://Scenes/Bullet/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawnBullet(direction):
	var bullet = bulletObj.instantiate()
	bullet.position.x = $BulletSpawn.global_position.x
	bullet.position.y = $BulletSpawn.global_position.y
	bullet.scale.y = 0.1
	bullet.scale.x = 0.1
	bullet.direction = direction
	get_tree().get_root().add_child(bullet)
	
	pass
