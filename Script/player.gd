extends CharacterBody2D

const SPEED = 300.0
const MAX_JUMP_VELOCITY = -600.0
const MIN_JUMP_VELOCITY = -150.0
const CHARGE_TIME = 1.0  # dalam detik

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var jump_charge_time := 0.0
var is_charging_jump := false

func _physics_process(delta: float) -> void:
	# Tambah gravitasi
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle jump charging
	if is_on_floor():
		if Input.is_action_pressed("ui_accept"):
			is_charging_jump = true
			jump_charge_time += delta
			jump_charge_time = clamp(jump_charge_time, 0, CHARGE_TIME)
		elif Input.is_action_just_released("ui_accept") and is_charging_jump:
			var charge_ratio := jump_charge_time / CHARGE_TIME
			var jump_strength: float = lerp(MIN_JUMP_VELOCITY, MAX_JUMP_VELOCITY, float(charge_ratio))
			velocity.y = jump_strength
			jump_charge_time = 0.0
			is_charging_jump = false
		else:
			jump_charge_time = 0.0
			is_charging_jump = false
	else:
		jump_charge_time = 0.0
		is_charging_jump = false

	# Gerakan kiri/kanan
	var direction := 0
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("move_left"):
		direction -= 1
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("move_right"):
		direction += 1

	if direction != 0:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Animasi berdasarkan kondisi
	if not is_on_floor():
		sprite.play("jump")
	elif is_charging_jump:
		sprite.play("charge")
	elif direction != 0:
		sprite.play("walk")
	else:
		sprite.play("Idle")
