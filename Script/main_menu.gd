extends Control

const SAVE_PATH := "user://save_data.save"

@onready var reset_button: Button = $Setting/ResetButton
@onready var confirm_dialog: ConfirmationDialog = $Setting/ResetConfirmDialog
@onready var menu_ui = $MainMenu
@onready var settings_ui = $Setting
@onready var settings_button = $MainMenu/VBoxContainer/SettingsButton
@onready var back_button = $Setting/Back
@onready var slider = $Setting/HSlider1
@onready var slider2 = $Setting/HSlider2

func _ready():
	reset_button.pressed.connect(_on_reset_pressed)
	confirm_dialog.confirmed.connect(_do_reset)
	# Tombol Main Menu
	$MainMenu/VBoxContainer/PlayButton.pressed.connect(_on_play_pressed)
	$MainMenu/VBoxContainer/SettingsButton.pressed.connect(_on_settings_pressed)
	$MainMenu/VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)

	# Tombol untuk overlay Settings
	settings_ui.hide()
	settings_button.pressed.connect(show_settings)
	back_button.pressed.connect(hide_settings)
	
	#main ulang musik
	Music.play_menu_music()

func _on_reset_pressed():
	confirm_dialog.popup_centered()

func _do_reset():
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
		print("Data save berhasil direset.")
	else:
		print("Tidak ada file save yang ditemukan.")

func _on_play_pressed():
	var transition = preload("res://Scene/transition.tscn").instantiate()
	get_tree().root.add_child(transition)

	transition.on_transition_finished.connect(func():
		get_tree().change_scene_to_file("res://Scene/Game.tscn")
	)
	
	transition.transition()

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
