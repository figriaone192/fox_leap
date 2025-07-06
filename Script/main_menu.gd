extends Control

@onready var menu_ui = $MainMenu
@onready var settings_ui = $Setting
@onready var settings_button = $MainMenu/VBoxContainer/SettingsButton
@onready var back_button = $Setting/HSlider/Button


func _ready():
	# Tombol Main Menu
	$MainMenu/VBoxContainer/PlayButton.pressed.connect(_on_play_pressed)
	$MainMenu/VBoxContainer/SettingsButton.pressed.connect(_on_settings_pressed)
	$MainMenu/VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)

	# Tombol untuk overlay Settings
	settings_ui.hide()
	settings_button.pressed.connect(show_settings)
	back_button.pressed.connect(hide_settings)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scene/game.tscn")

func _on_settings_pressed():
	print("Settings belum dibuat")

func _on_quit_pressed():
	get_tree().quit()

# Fungsi overlay Settings
func show_settings():
	menu_ui.hide()
	settings_ui.show()

func hide_settings():
	settings_ui.hide()
	menu_ui.show()

func _on_play_button_mouse_entered():
	$MainMenu/VBoxContainer/HoverBtn.play()

func _on_settings_button_mouse_entered():
	$MainMenu/VBoxContainer/HoverBtn.play()

func _on_quit_button_mouse_entered():
	$MainMenu/VBoxContainer/HoverBtn.play()

func _on_play_button_pressed():
	$MainMenu/VBoxContainer/ClickBtn.play()

func _on_settings_button_pressed():
	$MainMenu/VBoxContainer/ClickBtn.play()

func _on_quit_button_pressed():
	$MainMenu/VBoxContainer/ClickBtn.play()
