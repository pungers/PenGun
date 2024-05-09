class_name Enemy
extends CharacterBody2D

@onready var player = get_tree().get_nodes_in_group("Player")[0]
var direction
var friction = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var distance = player.global_position - global_position
	
	var theta = atan(distance.y / distance.x)
	direction = distance.normalized()
	
	if distance.x < 0:
		theta -= PI
	#sp += (4 * PI + PI / 3) * delta
	#direction = Vector2(cos(theta) - 1 * sin(theta), sin(theta) + cos(theta))
	rotateTo(theta)
	
	var collisionInfo = move_and_collide(velocity * delta)
	if collisionInfo:
		velocity = velocity.bounce(collisionInfo.get_normal())
		#velocity *= Vector2(100, 100)
		collisionInfo.get_collider().set("velocity", velocity * -1 * .5)
			
	velocity = velocity.move_toward(Vector2(0,0), .75)
	pass

func rotateTo(angle):
	$Weapon.rotation = angle
	#$Weapon2.rotation = angle
	pass

func _on_timer_timeout():
	$Weapon.spawnBullet(direction)
	#$Weapon2.spawnBullet(-direction)
	pass # Replace with function body.
