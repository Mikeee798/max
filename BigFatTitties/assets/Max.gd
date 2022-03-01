extends KinematicBody

var speed = 10
var h_acceleration = 12
var gravity = 20
var jump = 10

var mouse_sensitivity= 0.25

var direction = Vector3()
var h_velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()

onready var head = $head

func _ready():
	# Lock mouse onto gamescreen
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

func _physics_process(delta):
	
	direction = Vector3()
	
	# Do gravity
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * delta
	else:
		gravity_vec = -get_floor_normal() * gravity
	
	# Check if jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		gravity_vec = Vector3.UP * jump
	
	# Change speed if shift and forward are pressed
	if Input.is_action_pressed("shift_mod") && Input.is_action_pressed("move_forward"):
		speed = 10*2
	else:
		speed = 10
	
	# Move forward and backward
	if Input.is_action_pressed("move_forward") && Input.is_action_pressed("move_backward"):
		# Do nothing if both keys are pressed
		pass
	elif Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	
	# Move left and right
	if Input.is_action_pressed("move_left") && Input.is_action_pressed("move_right"):
		# Do nothing if both keys are pressed
		pass
	elif Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	
	# Normalize movement, apply movement
	direction = direction.normalized()
	h_velocity = h_velocity.linear_interpolate(direction * speed, h_acceleration * delta)
	movement.z = h_velocity.z + gravity_vec.z
	movement.x = h_velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	
	move_and_slide(movement, Vector3.UP)
