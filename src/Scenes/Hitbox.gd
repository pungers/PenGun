class_name Hitbox
extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_area_entered(hurtbox: Hurtbox):
	if !hurtbox.get_parent().is_in_group(get_groups()[0]):
		queue_free()
	pass # Replace with function body.
