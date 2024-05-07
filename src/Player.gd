extends Node

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
	
	# if the character isnt sliding reset velocity
	if !sliding:
		$CharacterBody2D.velocity = Vector2(0,0)
	elif !(Input.is_action_pressed("move_down") || Input.is_action_pressed("move_up") || Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left")):
		#if user isnt inputting anything, move towards 0
		$CharacterBody2D.velocity = $CharacterBody2D.velocity.move_toward(Vector2(0,0), delta * 3500)
	
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
		input *= speed * delta * 5
	else:
		input *= speed * delta * 250
		
	
	# add velocity to input
	$CharacterBody2D.velocity += input
	
	#limit sliding velocity
	$CharacterBody2D.velocity = get_node("CharacterBody2D").velocity.limit_length(300.0)

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
	if $CharacterBody2D.velocity.length() <= 20:
		sliding = false
		
	# collide if sliding
	if sliding:
		var collisionInfo = $CharacterBody2D.move_and_collide($CharacterBody2D.velocity * delta)
		slidingTimer -= delta * 100
		
		if collisionInfo:
			$CharacterBody2D.velocity = $CharacterBody2D.velocity.bounce(collisionInfo.get_normal())
			$CharacterBody2D.velocity -= Vector2(100 * delta, 100 * delta)
	else:
		$CharacterBody2D.move_and_slide()
		slidingTimer += delta * 500
		slidingTimer = clamp(slidingTimer, 0, 1000)

	pass
