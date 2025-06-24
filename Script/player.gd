extends CharacterBody2D

# Movement constants
const SPEED: float = 250.0
const MAX_JUMP_VELOCITY: float = -1000.0
const MIN_JUMP_VELOCITY: float = -150.0
const CHARGE_TIME: float = 1.0
const JUMP_HORIZONTAL_FORCE: float = 250.0

# Camera grid control
const ROOM_SIZE: Vector2 = Vector2(1920, 1080)

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = $Camera2D

# State variables
var jump_charge_time: float = 0.0
var is_charging_jump: bool = false
var facing_direction: int = 1  # 1 = kanan, -1 = kiri

# Kamera ruangan
var current_room: Vector2 = Vector2.ZERO
var target_camera_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	camera.make_current()
	_update_camera_room(true)

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

	# Flip sprite arah hadap
	if direction != 0:
		facing_direction = direction
		sprite.flip_h = facing_direction < 0

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

			# Tambahan dorongan horizontal saat lompat
			if direction == 0:
				velocity.x = facing_direction * (JUMP_HORIZONTAL_FORCE * 1.5)  # loncat ke arah hadap
			else:
				velocity.x = direction * JUMP_HORIZONTAL_FORCE

			jump_charge_time = 0.0
			is_charging_jump = false
		else:
			jump_charge_time = 0.0
			is_charging_jump = false
	else:
		jump_charge_time = 0.0
		is_charging_jump = false

	# Gerak horizontal
	if is_on_floor() and not is_charging_jump:
		if direction != 0:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

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

	var room_changed: bool = (new_room != current_room)

	if force or room_changed:
		current_room = new_room
		target_camera_pos = current_room * ROOM_SIZE + ROOM_SIZE / 2.0

func _move_camera() -> void:
	camera.global_position = target_camera_pos
