extends Weapon

# controlls the spread of the shotgun
var theta_range = 1.12
var n = 5 # amount of bullets



var rotation_lower_bound = theta_range / 2 * -1 # the lower bound of which to rotate by
var rotation_higher_bound = theta_range / 2 * 1
var direction_ranges = {}

func _ready():
	# interpolate between the extremes, figure out the fence posts
	# visualize them here given a certain theta range
	# https://www.desmos.com/calculator/bskfxx0yxl
	for i in range(n + 1):
		direction_ranges[i] = rotation_lower_bound + (theta_range * (i / float(n)))


func spawnBullet(direction, group):
	
	# bullet dictionary
	var bullets = {}
	
	for i in range(n):
		bullets[i] = bulletObj.instantiate()
		bullets[i].add_to_group(group)
		bullets[i].position.x = $BulletSpawn.global_position.x
		bullets[i].position.y = $BulletSpawn.global_position.y
		bullets[i].scale.y = 0.1
		bullets[i].scale.x = 0.1
		
		var new_direction = direction.rotated(randf_range(direction_ranges[i], direction_ranges[i + 1]))
		bullets[i].direction = new_direction * BULLET_SPEED
		get_tree().get_root().add_child(bullets[i])
