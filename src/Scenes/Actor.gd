class_name Actor
extends CharacterBody2D

var hp
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func decreaseHp(hpDecrease):
	hp -= hpDecrease
