extends CharacterBody3D

const SPEED = 7.00
var mouse_sensitivity = 700
var rotation_target: Vector3
var input_mouse: Vector2
@onready var camera: Camera3D = $Camera3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	var vertical := Input.get_action_strength(&"move_up") - Input.get_action_strength(&"move_down")
	var input_dir := Input.get_vector(&"move_left", &"move_right", &"move_forward", &"move_backward")
	var fast := Input.get_action_strength(&"speedup") + 1
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	velocity.y = vertical * SPEED * fast
	if direction:
		velocity.x = direction.x * SPEED * fast
		velocity.z = direction.z * SPEED * fast
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	camera.rotation.z = lerp_angle(camera.rotation.z, -input_mouse.x * 25 * delta, delta * 5)	
	camera.rotation.x = lerp_angle(camera.rotation.x, rotation_target.x, delta * 25)
	rotation.y = lerp_angle(rotation.y, rotation_target.y, delta * 25)

	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		input_mouse = event.relative / mouse_sensitivity
		rotation_target.y -= event.relative.x / mouse_sensitivity
		rotation_target.x -= event.relative.y / mouse_sensitivity
