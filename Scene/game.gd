extends Node2D

@onready var pause_menu = $PauseMenu
var input_enabled := false  # Tambahkan flag input manual

func _ready():
	input_enabled = false               # Matikan input
	await get_tree().create_timer(1.0).timeout  # Tunggu 1 detik
	input_enabled = true                # Baru boleh input

func _unhandled_input(event):
	if not input_enabled:
		return  # Abaikan semua input jika belum 1 detik

	if event.is_action_pressed("ui_cancel"):  # ESC default-nya "ui_cancel"
		if get_tree().paused:
			pause_menu.hide_pause_menu()
		else:
			pause_menu.show_pause_menu()
