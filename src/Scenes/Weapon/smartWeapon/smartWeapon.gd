extends Weapon

# what the player is doing right now
var input = Vector2()

@onready var player = get_tree().get_nodes_in_group("Player")[0] #grab the player

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

func spawnBullet(direction, group):
	
	var bullet = bulletObj.instantiate()
	bullet.add_to_group(group)
	bullet.position.x = $WeaponSprite/BulletSpawn.global_position.x
	bullet.position.y = $WeaponSprite/BulletSpawn.global_position.y
	bullet.scale.y = 0.1
	bullet.scale.x = 0.1
	
	
	bullet.direction = calculateDirection(bullet) * BULLET_SPEED
	get_tree().get_root().add_child(bullet)
	
	pass
	
func calculateDirection(bullet):
	# work i did to calculate the direction the bullet must travel in
	# https://www.desmos.com/calculator/tporimds96
	# https://www.desmos.com/calculator/9mqwhd5otv
	# https://www.wolframalpha.com/input?i2d=true&i=a+%2B+bcos%5C%2840%29x%5C%2841%29+-+csin%5C%2840%29x%5C%2841%29+%3D+0
	
	
	#wolfram alpha is so good
	
	# difference between player and bullet
	# also change of variables because the coordinate space is mirrored and i prefer to work in standard x y axis
	var d_y = -1 * player.global_position.y - -1 * bullet.global_position.y # difference between bullet and the player
	var d_x = player.global_position.x - bullet.global_position.x
	var ps_x = player.velocity.x # players speed x component
	var ps_y = player.velocity.y # players speed y component (change of variables)
	var bs = BULLET_SPEED
		
	#simplifying calcuations
	var a = -1 * d_y * ps_x - d_x * ps_y
	var b = d_y * bs
	var c = d_x * bs
	
	a /= 1000
	b /= 1000
	c /= 1000
	
	#there is a rare case this results in undefined, but i doubt it'll ever actually come up
	# specifically when the inside is 0 or if a - b is zero
	var theta = 2 * atan( (c - sqrt( -1 * (a ** 2) + b ** 2 + c ** 2))/(a - b))
	
	
	return Vector2(cos(theta), -1 * sin(theta))
