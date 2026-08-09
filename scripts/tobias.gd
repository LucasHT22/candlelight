extends CharacterBody2D

signal doused

@export var flame_light: PointLight2D
@export var flame_energy_label: Label;
@export var ambient_energy: float = 0.15
@export var lit_energy: float = 2.5
@export var lit_duration: float = 1.5
@export var initial_flame: float = lit_duration * 20

var is_lit: bool = false
var lit_timer: float = 0.0
var light_brightness: float = 0;
var flame_energy = initial_flame;

const SPEED = 300.0
const JUMP_VELOCITY = -1000.0
const JUMP_DELAY = 0.5

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_jumping := false

func douse() -> void:
	emit_signal("doused")
	get_tree().reload_current_scene()

func light_up() -> void:
	if flame_energy > 0:
		is_lit = true
		lit_timer = lit_duration
		flame_light.energy = lit_energy

func _ready() -> void:
	_set_ambient()
	_update_label()
	
func _set_ambient() -> void:
	is_lit = false
	flame_light.energy = ambient_energy
	
func _update_brightness(percent: float) -> void:
	if flame_energy <= 0:
		light_brightness = 0
	else:
		light_brightness = percent * lit_energy
	
	flame_light.energy = light_brightness
	
	if light_brightness <= 0:
		light_brightness = 0
		is_lit = false

func _update_label() -> void:
	flame_energy_label.text = "Flame: " + str(int(round(flame_energy)))

func _process(delta: float) -> void:
	if is_lit:
		lit_timer -= delta
		flame_energy -= delta
		
		_update_label()
		
		_update_brightness(lit_timer / lit_duration)
			
	if Input.is_action_pressed("light"):
		light_up()

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


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("spikes"):
		get_tree().reload_current_scene()
