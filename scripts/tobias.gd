extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -1000.0
const JUMP_DELAY = 0.5

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_jumping := false  # true durante o delay + o pulo em si

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_jumping:
		start_jump()

	# Get the input direction and handle the movement/deceleration.
	# Bloqueia movimento horizontal durante o delay do pulo.
	if not is_jumping:
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		update_animation(direction)
	else:
		velocity.x = 0

	move_and_slide()


func start_jump() -> void:
	is_jumping = true
	velocity.x = 0
	animated_sprite.play("jump")

	await get_tree().create_timer(JUMP_DELAY).timeout

	velocity.y = JUMP_VELOCITY
	is_jumping = false


func update_animation(direction: float) -> void:
	if direction != 0:
		if animated_sprite.animation != "walk" or not animated_sprite.is_playing():
			animated_sprite.play("walk")
		animated_sprite.flip_h = direction < 0
	elif not is_on_floor():
		pass
	else:
		if animated_sprite.animation != "idle":
			animated_sprite.play("idle")
