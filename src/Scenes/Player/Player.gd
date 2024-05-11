extends Actor

var speed = 100
var sliding = false
var drifting = false
var slidingDepleted = false
var slidingTimer = 1000
var boostTimer = 0

signal camZoom
signal slidingTimerSignal

# Called when the node enters the scene tree for the first time.
func _ready():
	hp = 100
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(hp)
	#sEngine.max_fps = 60
	var input = Vector2(0, 0)
	
	#%Camera2D.global_position = lerp(%Camera2D.global_position, global_position, delta * .1)
	var mousePos = get_viewport().get_mouse_position()
	# center mouse position
	mousePos.x -= get_viewport().size.x / 2
	mousePos.y -= get_viewport().size.y / 2
	mousePos += global_position - get_parent().get_node("Camera2D").global_position
	#print(get_parent().get_node("Camera2D").global_position - position)
	
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
		global_rotation -= (global_rotation) * delta * 5
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
		
	if sliding:
		$Smoothing2D/Sprite2D.scale.x = (1.00 + velocity.length() / 1500) * 0.156
		$Smoothing2D/Sprite2D.scale.y = (1.00 - velocity.length() / 1500) * 0.156
	else:
		if ($Smoothing2D/Sprite2D.scale.x > 0.156):
			$Smoothing2D/Sprite2D.scale.x -= ($Smoothing2D/Sprite2D.scale.x - 0.156) * delta * 5
			clamp($Smoothing2D/Sprite2D.scale.x, 0.156, $Smoothing2D/Sprite2D.scale.x)
		if ($Smoothing2D/Sprite2D.scale.y < 0.156):
			$Smoothing2D/Sprite2D.scale.y -= ($Smoothing2D/Sprite2D.scale.y - 0.156) * delta * 5
			clamp($Smoothing2D/Sprite2D.scale.y, $Smoothing2D/Sprite2D.scale.y, 0.156)

	# emit singal to UI
	emit_signal("slidingTimerSignal", slidingTimer)
	
	if boostTimer > 0 && !drifting:
		boostTimer -= delta *  100

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
		slidingTimer -= delta * 75
		boostTimer += 50 * delta
		velocity = lerp(velocity, Vector2(0, 0), delta * 2)
		#input = input.cross(velocity) 
	elif sliding && boostTimer <= 0:
		inputSpeed *= speed * delta * 20
	elif boostTimer <= 0:
		inputSpeed *= speed * 2

	# add input to velocity
	if boostTimer <= 0 && !drifting:
		print("hi")
		velocity += inputSpeed
	
	# if shifting slide
	if Input.is_action_pressed("shift") && slidingTimer > 0 && !slidingDepleted:
		sliding = true;
	elif Input.is_action_pressed("shift") && slidingTimer > 250:
		sliding = true
		slidingDepleted = false;
	elif boostTimer == 0:
		sliding = false
	
	# if speed is less than 20, stop sliding
	if velocity.length() <= 20 && boostTimer <= 0:
		sliding = false
	# if slidingTimer is depleted stop
	if slidingTimer <= 0 && boostTimer <= 0:
		sliding = false
		slidingDepleted = true
	
	if Input.is_action_pressed("rclick") && boostTimer <= 0 && slidingTimer >= 250:
		drifting = true
		sliding = true
	
	if (Input.is_action_just_released("rclick") || slidingTimer <= 0) && drifting:
		velocity = mousePos.normalized() * (350 + 350 * boostTimer / 100)
		drifting = false
		
	# collide if sliding
	#if drifting:
	#	move_and_slide()
	
	boostTimer = clamp(boostTimer, 0, 100)
func _input(event):
	pass

func _physics_process(delta):
		#limit sliding velocity
	if boostTimer <= 0:
		velocity = velocity.limit_length(350.0)
	else:
		velocity = velocity.limit_length(350 + 1000 * boostTimer / 100)
		
	if sliding:
		velocity = velocity.move_toward(Vector2(0,0), delta * 125)
		var collisionInfo = move_and_collide(velocity * delta)
		slidingTimer -= delta * 100
		
		if collisionInfo:
			print(velocity)
			collisionInfo.get_collider().set("velocity", velocity * 0.5)
			velocity = velocity.bounce(collisionInfo.get_normal())
			velocity *= 1.25
			if collisionInfo.get_collider().is_in_group("Enemy"):
				#collisionInfo.get_collider().decreaseHp(10)
				# freeze frames
				if velocity.length() > 500:
					emit_signal("camZoom", Vector2(3, 3) * (velocity.length()) / 750)
					freezeFrame(0.05, 0.75 * velocity.length() / 750)
				else:
					freezeFrame(0.05, 0.1 * velocity.length() / 500)
	else:
		move_and_slide()
		slidingTimer += delta * 500
		slidingTimer = clamp(slidingTimer, 0, 1000)

func freezeFrame(timescale, duration):
	Engine.time_scale = timescale
	var timer = get_tree().create_timer(duration * timescale)
	await(timer.timeout)
	Engine.time_scale = 1.0

