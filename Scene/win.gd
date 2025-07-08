extends Node2D
func _on_main_menu_pressed():
	get_tree().paused = false
	var transition = preload("res://Scene/transition.tscn").instantiate()
	get_tree().root.add_child(transition)

	transition.on_transition_finished.connect(func():
		get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
	)
	
	transition.transition()
	$VBoxContainer/ClickBtn.play()
func _on_main_menu_mouse_entered() -> void:
	$VBoxContainer/HoverBtn.play()
