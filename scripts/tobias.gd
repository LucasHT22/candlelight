extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOdwCITY = -1000.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	update_animation(direction)

func update_animation(direction: float) -> void:
	if direction != 0:
		if animated_sprite.animation != "walk" or not animated_sprite.is_playing():
			animated_sprite.play("walk")
		animated_sprite.flip_h = direction < 0
	elif not is_on_floor():
		# optional: play a jump/fall animation if you have one
		# if animated_sprite.animation != "jump":
		#     animated_sprite.play("jump")
		pass
	else:
		if animated_sprite.animation != "idle":
			animated_sprite.play("idle")
