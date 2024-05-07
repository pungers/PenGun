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
	
	if !sliding:
		get_node("CharacterBody2D").velocity = Vector2(0,0)
	elif !(Input.is_action_pressed("move_down") || Input.is_action_pressed("move_up") || Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left")):
		get_node("CharacterBody2D").velocity = get_node("CharacterBody2D").velocity.move_toward(Vector2(0,0), delta * 3500)
	
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
		
	
	get_node("CharacterBody2D").velocity += input
	if sliding:
		get_node("CharacterBody2D").velocity = get_node("CharacterBody2D").velocity.limit_length(300.0)
	#print(get_node("CharacterBody2D").velocity.length())

	if Input.is_action_pressed("shift") && slidingTimer > 0 && !slidingDepleted:
		sliding = true;
	elif Input.is_action_pressed("shift") && slidingTimer > 250:
		sliding = true
		slidingDepleted = false;
	else:
		sliding = false
	
	if slidingTimer <= 0:
		sliding = false
		slidingDepleted = true
		
		
	if get_node("CharacterBody2D").velocity.length() <= 20:
		sliding = false
		
	if sliding:
		var collisionInfo = get_node("CharacterBody2D").move_and_collide(get_node("CharacterBody2D").velocity * delta)
		slidingTimer -= delta * 100
		
		if collisionInfo:
			get_node("CharacterBody2D").velocity = get_node("CharacterBody2D").velocity.bounce(collisionInfo.get_normal())
			get_node("CharacterBody2D").velocity -= Vector2(100 * delta, 100 * delta)
	
	else:
		get_node("CharacterBody2D").move_and_slide()
		slidingTimer += delta * 500
		slidingTimer = clamp(slidingTimer, 0, 1000)

	pass
