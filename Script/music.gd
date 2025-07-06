extends Node2D

@onready var music_player = $MusicPlayer

func play_menu_music():
	music_player.stream = preload("res://Assets/Sound/sadforest.mp3")
	music_player.play(0.0)  # Start dari awal
