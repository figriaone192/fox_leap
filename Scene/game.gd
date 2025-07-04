extends Node2D
@onready var pause_menu = $PauseMenu  # Pastikan sudah di-add ke scene

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):  # ESC default-nya "ui_cancel"
		if get_tree().paused:
			pause_menu.hide_pause_menu()
		else:
			pause_menu.show_pause_menu()
