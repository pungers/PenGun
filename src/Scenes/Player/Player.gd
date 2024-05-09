extends CharacterBody2D

var speed = 100
var sliding = false
var slidingDepleted = false
var slidingTimer = 1000

signal slidingTimerSignal
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input = Vector2(0, 0)
	
	var mousePos = get_viewport().get_mouse_position()
	# center mouse position
	#mousePos.x -= get_viewport().size.x / 2
	#mousePos.y -= get_viewport().size.y / 2
	mousePos -= position
	
	var theta = atan(mousePos.y / mousePos.x)
	var direction = mousePos.normalized()
	
	if sliding:
		var phi = atan(velocity.y / velocity.x)
		if velocity.x < 0:
			phi -= PI
		global_rotation = phi
	else:
		global_rotation = 0

	if mousePos.x < 0:
		theta -= PI
	$Weapon.global_rotation = theta
	
	if Input.is_action_just_pressed("click"):
		$Weapon.spawnBullet(direction)
	
	# if the character isnt sliding reset velocity
	if !sliding:
		velocity = Vector2(0,0)
	#elif !(Input.is_action_pressed("move_down") || Input.is_action_pressed("move_up") || Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left")):
		#if user isnt inputting anything, move towards 0
	velocity = velocity.move_toward(Vector2(0,0), 1)
	
	# emit singal to UI
	emit_signal("slidingTimerSignal", slidingTimer)
	
	# get input
	if Input.is_action_pressed("move_down"):
		input.y += 1
	
	if Input.is_action_pressed("move_up"):
		input.y -= 1
		
	if Input.is_action_pressed("move_right"):
		input.x += 1
	
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	
	input = input.normalized()
	
	if sliding:
		# removing the extra delta actually makes it feel a lot worse
		# and that's because player input has too much influence 
		input *= speed * .1
	else:
		# also you realize that before you were multipling speed by 200 right?
		# 100 * 200 = really big number
		input *= speed * 2
		
	
	if sliding:
		set_collision_layer_value(4, true)
		set_collision_mask_value(4, true)
	else:
		set_collision_layer_value(4, false)
		set_collision_mask_value(4, false)
		
	
	# add velocity to input
	velocity += input
	
	#limit sliding velocity
	velocity = velocity.limit_length(350.0)

	# if shifting slide
	if Input.is_action_pressed("shift") && slidingTimer > 0 && !slidingDepleted:
		sliding = true;
	elif Input.is_action_pressed("shift") && slidingTimer > 250:
		sliding = true
		slidingDepleted = false;
	else:
		sliding = false
	
	# if slidingTimer is depleted stop
	if slidingTimer <= 0:
		sliding = false
		slidingDepleted = true
	
	# if speed is less than 20, stop sliding
	if velocity.length() <= 20:
		sliding = false
		
	# collide if sliding
	if sliding:
		var collisionInfo = move_and_collide(velocity * delta)
		slidingTimer -= delta * 100
		
		if collisionInfo:
			velocity = velocity.bounce(collisionInfo.get_normal())
			#velocity *= Vector2(100, 100)
			collisionInfo.get_collider().set("velocity", velocity * -1 * .5)
	else:
		move_and_slide()
		slidingTimer += delta * 500
		slidingTimer = clamp(slidingTimer, 0, 1000)
