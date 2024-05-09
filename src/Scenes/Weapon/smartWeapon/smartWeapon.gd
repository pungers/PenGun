extends Weapon

# what the player is doing right now
var input = Vector2()

@onready var player = get_tree().get_nodes_in_group("Player")[0] #grab the player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# take into account player inpute	
	input = Vector2(0, 0)
	
	if Input.is_action_pressed("move_down"):
		input.y += 1
	
	if Input.is_action_pressed("move_up"):
		input.y -= 1
		
	if Input.is_action_pressed("move_right"):
		input.x += 1
	
	if Input.is_action_pressed("move_left"):
		input.x -= 1
		
	input = input.normalized()

func spawnBullet(direction):
	
	var bullet = bulletObj.instantiate()
	bullet.position.x = $WeaponSprite/BulletSpawn.global_position.x
	bullet.position.y = $WeaponSprite/BulletSpawn.global_position.y
	bullet.scale.y = 0.1
	bullet.scale.x = 0.1
	
	
	bullet.direction = calculateDirection(bullet) * BULLET_SPEED
	get_tree().get_root().add_child(bullet)
	
	print(bullet.direction)
	
	pass
	
func calculateDirection(bullet):
	#holy shit wolfram alpha is so good
	# BULLET_SPEED
	
	# difference between player and bullet
	# also change of variables because computer scientists are silly
	var d_y = -1 * player.global_position.y - -1 * bullet.global_position.y
	var d_x = player.global_position.x - bullet.global_position.x
	var ps_x = player.velocity.x # players speed x component
	var ps_y = player.velocity.y # players speed y component (change of variables)
	var bs = BULLET_SPEED
		
	#formula wolfram alpha gave it to me
	var a = -1 * d_y * ps_x - d_x * ps_y
	var b = d_y * bs
	var c = d_x * bs
	
	var theta = 2 * atan( (c - sqrt( -1 * (a ** 2) + b ** 2 + c ** 2))/(a - b))
	print(player.global_position.x, " ", player.global_position.y)
	print(bullet.global_position.x, " ", bullet.global_position.y)
	print(d_y, " ", d_x)
	print(ps_x, " ", ps_y)
	print(a, " ", b, " ", c, " ", theta)
	print(Vector2(cos(theta), -1 * sin(theta)))
	
	return Vector2(cos(theta), -1 * sin(theta))
