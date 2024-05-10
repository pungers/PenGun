extends Actor

var speed = 100
var sliding = false
var drifting = false
var slidingDepleted = false
var slidingTimer = 1000
var driftingTimer = 0
var boostTimer = 0

signal slidingTimerSignal
# Called when the node enters the scene tree for the first time.
func _ready():
	hp = 100
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(hp)
	var input = Vector2(0, 0)
	
	var mousePos = get_viewport().get_mouse_position()
	# center mouse position
	mousePos.x -= get_viewport().size.x / 2
	mousePos.y -= get_viewport().size.y / 2
	
	var theta = atan(mousePos.y / mousePos.x)
	var direction = mousePos.normalized()
	
	if mousePos.x < 0:
		theta -= PI

	# rotating the main sprtie
	if drifting:
		global_rotation = theta
	elif sliding:
		var phi = atan(velocity.y / velocity.x)
		if velocity.x < 0:
			phi -= PI
		global_rotation = phi
	else:
		global_rotation = 0
	$Weapon.global_rotation = theta
	if drifting:
		$Arrow.scale.x = boostTimer/100.0
		$Arrow.global_rotation = theta
	else:
		$Arrow.scale.x = 0
	
	if Input.is_action_just_pressed("click"):
		$Weapon.spawnBullet(direction, "Player")
	
	# if the character isnt sliding reset velocity
	if !sliding:
		velocity = Vector2(0,0)
	elif boostTimer > 0:
		sliding = true
		velocity = velocity.move_toward(Vector2(0,0), 1)

	# emit singal to UI
	emit_signal("slidingTimerSignal", slidingTimer)
	
	if boostTimer > 0 && !drifting:
		boostTimer -= delta * 100
	elif boostTimer <= 0 && !drifting:
		boostTimer = 0
	
	# get input
	if Input.is_action_pressed("move_down"):
		input.y += 1
	
	if Input.is_action_pressed("move_up"):
		input.y -= 1
		
	if Input.is_action_pressed("move_right"):
		input.x += 1
	
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	
	var inputSpeed = input.normalized()
	
	if drifting:
		if boostTimer < 100:
			boostTimer += 50 * delta
		if boostTimer > 100:
			boostTimer = 100
		velocity *= .9925
		#input = input.cross(velocity) 
	elif sliding:
		inputSpeed *= speed * .1
	else:
		inputSpeed *= speed * 2
		
	
	if sliding:
		set_collision_layer_value(4, true)
		set_collision_mask_value(4, true)
	else:
		set_collision_layer_value(4, false)
		set_collision_mask_value(4, false)
		
	
	# add input to velocity
	if !drifting:
		velocity += inputSpeed
	
	#limit sliding velocity
	if boostTimer <= 0:
		velocity = velocity.limit_length(350.0)
	else:
		velocity = velocity.limit_length(350 + 1000 * boostTimer / 100)
	
	if sliding && Input.is_action_just_released("shift") && boostTimer <= 0:
		driftingTimer = 2
	
	if driftingTimer > 0:
		driftingTimer -= delta * 10
	elif driftingTimer < 0:
		driftingTimer = 0
	if driftingTimer > 0 && Input.is_action_pressed("shift"):
		driftingTimer = 0
		drifting = true
	
	if drifting && Input.is_action_just_released("shift"):
		velocity = mousePos.normalized() * (350 + 350 * boostTimer / 100)
		drifting = false
	# if shifting slide
	if Input.is_action_pressed("shift") && slidingTimer > 0 && !slidingDepleted:
		sliding = true;
	elif Input.is_action_pressed("shift") && slidingTimer > 250:
		sliding = true
		slidingDepleted = false;
	elif driftingTimer == 0 && boostTimer == 0:
		sliding = false
		
	# if slidingTimer is depleted stop
	if slidingTimer <= 0:
		sliding = false
		slidingDepleted = true
	
	# if speed is less than 20, stop sliding
	if velocity.length() <= 20 && boostTimer <= 0:
		sliding = false
		
	if $Camera2D.zoom > Vector2(2, 2):
		$Camera2D.zoom -= Vector2(delta * 3 * ($Camera2D.zoom.x - 2), delta * 3 * ($Camera2D.zoom.y - 2))
	elif $Camera2D.zoom < Vector2(2,2):
		$Camera2D.zoom = Vector2(2,2)
		
	# collide if sliding
	#if drifting:
	#	move_and_slide()
	if sliding:
		var collisionInfo = move_and_collide(velocity * delta)
		slidingTimer -= delta * 100
		
		if collisionInfo:
			velocity = velocity.bounce(collisionInfo.get_normal())
			collisionInfo.get_collider().set("velocity", velocity * -0.5)
			if collisionInfo.get_collider().is_in_group("Enemy"):
				collisionInfo.get_collider().decreaseHp(10)
				# freeze frames
				if velocity.length() > 450:
					$Camera2D.zoom = Vector2(4, 4) * (velocity.length()) / 750
					freezeFrame(0.05, velocity.length() / 750)
	else:
		move_and_slide()
		slidingTimer += delta * 500
		slidingTimer = clamp(slidingTimer, 0, 1000)

func freezeFrame(timescale, duration):
	Engine.time_scale = timescale
	var timer = get_tree().create_timer(duration * timescale)
	await(timer.timeout)
	Engine.time_scale = 1.0
	
