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

func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
