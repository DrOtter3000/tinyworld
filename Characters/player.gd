extends CharacterBody3D

@onready var camera_3d: Camera3D = $Camera3D
@export var mouse_sensetivity := .075
@export var speed := 15


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensetivity))
		camera_3d.rotate_x(deg_to_rad(-event.relative.y * mouse_sensetivity))
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-85), deg_to_rad(85))
		
