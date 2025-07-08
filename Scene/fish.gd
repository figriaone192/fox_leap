extends Area2D

signal fish_touched

func _on_body_entered(body):
	get_tree().paused = false
	var transition = preload("res://Scene/transition.tscn").instantiate()
	get_tree().root.add_child(transition)
	if body.name == "Player":
		emit_signal("fish_touched")
