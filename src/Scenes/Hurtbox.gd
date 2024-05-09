class_name Hurtbox
extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_area_entered(hitbox: Hitbox):
	if get_parent().has_method("decreaseHp") && not get_parent().is_in_group(hitbox.get_groups()[0]):
		get_parent().decreaseHp(10)
	pass
