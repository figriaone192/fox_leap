extends CharacterBody2D

# Movement constants
const SPEED: float = 250.0
const MAX_JUMP_VELOCITY: float = -900.0
const MIN_JUMP_VELOCITY: float = -150.0
const CHARGE_TIME: float = 1.0
const JUMP_HORIZONTAL_FORCE: float = 250.0
const WALL_KNOCKBACK_FORCE: float = 200.0
const SAVE_PATH := "user://save_data.save"


# Camera grid control
const ROOM_SIZE: Vector2 = Vector2(1920, 1080)

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = $Camera2D

# UI labels
@onready var jump_label: Label = get_tree().get_root().get_node("Game/UI Layer/label_jump")
@onready var time_label: Label = get_tree().get_root().get_node("Game/UI Layer/timestamp")

# Sounds
@onready var jump_sound = $jump
@onready var walk_sound = $walk
@onready var crash_sound = $bump

# State variables
var jump_charge_time: float = 0.0
var is_charging_jump: bool = false
var facing_direction: int = 1

var jump_count: int = 0
var has_started_timer: bool = false
var time_since_first_jump: float = 0.0
var was_on_floor: bool = false

# Camera logic
var current_room: Vector2 = Vector2.ZERO
var target_camera_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	camera.make_current()
	_update_camera_room(true)

	# Load posisi player jika file save tersedia
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var data = file.get_var()
		file.close()

		if typeof(data) == TYPE_DICTIONARY:
			global_position = data.get("position", global_position)
			jump_count = data.get("jump_count", 0)
			time_since_first_jump = data.get("time", 0.0)
			has_started_timer = true  # langsung mulai timer setelah load

		print("Loaded save:", data)


	jump_label.text = "TOTAL JUMP: " + str(jump_count)
	time_label.text = "TIME: %02d:%02d.%02d" % [
		int(time_since_first_jump) / 60,
		int(time_since_first_jump) % 60,
		int((time_since_first_jump - int(time_since_first_jump)) * 100)
	]


func _physics_process(delta: float) -> void:
	# Tambah gravitasi
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Input arah
	var direction: int = 0
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("move_left"):
		direction -= 1
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("move_right"):
		direction += 1

	# Flip sprite
	if direction != 0:
		facing_direction = direction
		sprite.flip_h = facing_direction < 0

	# Suara langkah
	var is_moving = direction != 0
	if is_on_floor() and is_moving and not is_charging_jump:
		if not walk_sound.playing:
			walk_sound.pitch_scale = randf_range(0.95, 1.05)
			walk_sound.play()
	else:
		if walk_sound.playing:
			walk_sound.stop()

	# Jump charge
	if is_on_floor():
		if Input.is_action_pressed("ui_accept"):
			is_charging_jump = true
			jump_charge_time += delta
			jump_charge_time = clamp(jump_charge_time, 0, CHARGE_TIME)
			velocity.x = 0
		elif Input.is_action_just_released("ui_accept") and is_charging_jump:
			var charge_ratio: float = jump_charge_time / CHARGE_TIME
			velocity.y = lerp(MIN_JUMP_VELOCITY, MAX_JUMP_VELOCITY, charge_ratio)

			if direction == 0:
				velocity.x = facing_direction * (JUMP_HORIZONTAL_FORCE * 1.5)
			else:
				velocity.x = direction * JUMP_HORIZONTAL_FORCE

			# Tambah lompatan & timer
			jump_count += 1
			jump_label.text = "TOTAL JUMP: " + str(jump_count)

			if not has_started_timer:
				has_started_timer = true

			# Suara lompat
			jump_sound.play()

			jump_charge_time = 0.0
			is_charging_jump = false
		else:
			jump_charge_time = 0.0
			is_charging_jump = false
	else:
		jump_charge_time = 0.0
		is_charging_jump = false

	# Gerak horizontal di tanah
	if is_on_floor() and not is_charging_jump:
		if direction != 0:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Timer
	if has_started_timer:
		time_since_first_jump += delta
		var minutes = int(time_since_first_jump) / 60
		var seconds = int(time_since_first_jump) % 60
		var centiseconds = int((time_since_first_jump - int(time_since_first_jump)) * 100)
		time_label.text = "TIME: %02d:%02d.%02d" % [minutes, seconds, centiseconds]

	# Knockback
	if not is_on_floor():
		for i in range(get_slide_collision_count()):
			var collision := get_slide_collision(i)
			if collision:
				var normal = collision.get_normal()
				if abs(normal.x) > 0.9:
					velocity.x = normal.x * WALL_KNOCKBACK_FORCE
					velocity.y *= 0.9
					# Suara crash
					crash_sound.stop()
					crash_sound.pitch_scale = randf_range(0.95, 1.05)
					crash_sound.play()

	# Autosave saat mendarat
	if is_on_floor() and not was_on_floor:
		save_position()
	was_on_floor = is_on_floor()

	# Animasi
	if not is_on_floor():
		sprite.play("jump")
	elif is_charging_jump:
		sprite.play("charge")
	elif direction != 0:
		sprite.play("walk")
	else:
		sprite.play("Idle")

	# Kamera update
	_update_camera_room()
	_move_camera()

func _update_camera_room(force: bool = false) -> void:
	var player_pos: Vector2 = global_position
	var new_room: Vector2 = Vector2(
		floor(player_pos.x / ROOM_SIZE.x),
		floor(player_pos.y / ROOM_SIZE.y)
	)

	if force or (new_room != current_room):
		current_room = new_room
		target_camera_pos = current_room * ROOM_SIZE + ROOM_SIZE / 2.0

func _move_camera() -> void:
	camera.global_position = target_camera_pos

func save_position():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data = {
		"position": global_position,
		"jump_count": jump_count,
		"time": time_since_first_jump
	}
	file.store_var(data)
	file.close()
	print("Auto-saved at:", global_position, "jumps:", jump_count, "time:", time_since_first_jump)
