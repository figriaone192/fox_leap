extends CanvasLayer

@onready var resume_button = $VBoxContainer/Resume
@onready var main_menu_button = $VBoxContainer/MainMenu

func _ready():
	hide()  # Mulai dalam keadaan disembunyikan
	resume_button.pressed.connect(_on_resume_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)

func show_pause_menu():
	get_tree().paused = true
	show()

func hide_pause_menu():
	get_tree().paused = false
	hide()

func _on_resume_pressed():
	hide_pause_menu()
	$VBoxContainer/ClickBtn.play()

func _on_main_menu_pressed():
	get_tree().paused = false
	var transition = preload("res://transition.tscn").instantiate()
	get_tree().root.add_child(transition)

	transition.on_transition_finished.connect(func():
		get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
	)
	
	transition.transition()
	$VBoxContainer/ClickBtn.play()

func _on_resume_mouse_entered() -> void:
	$VBoxContainer/HoverBtn.play()

func _on_main_menu_mouse_entered() -> void:
	$VBoxContainer/HoverBtn.play()
