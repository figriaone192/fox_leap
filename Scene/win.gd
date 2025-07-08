extends Node2D

@onready var time_label: Label = $TimeLabel
@onready var jump_label: Label = $JumpLabel

func _ready():
	var path = "user://win_data.save"

	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var data = file.get_var()
		file.close()

		var time = data.get("time", 0.0)
		var jumps = data.get("jump_count", 0)

		var minutes = int(time) / 60
		var seconds = int(time) % 60
		var centiseconds = int((time - int(time)) * 100)

		time_label.text = "WAKTU: %02d:%02d.%02d" % [minutes, seconds, centiseconds]
		jump_label.text = "TOTAL LOMPATAN: " + str(jumps)
	else:
		time_label.text = "WAKTU: -"
		jump_label.text = "TOTAL LOMPATAN: -"
	
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
