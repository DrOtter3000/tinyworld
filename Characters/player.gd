extends CharacterBody3D

#Movement
@onready var camera_3d: Camera3D = $Camera3D
@onready var camera_position: Vector3 = camera_3d.position
@export var mouse_sensetivity := .075
@export var speed := 15

#Cambob
var _delta := 0.0
var direction := Vector3.ZERO
@export var cambob_speed := 5.0
@export var cambob_speed_in_no_motion := cambob_speed/5
@export var cambob_area := .25
@export var cambob_area_in_no_motion = cambob_area/2

#Footsteps
@onready var last_pos: Vector3 = global_position
@export var step_after_dist := 2
var dist_travelled_since_last_step := 0.0
@onready var step_player: AudioStreamPlayer = $StepPlayer
var wooden_plank_audio := [preload("res://Audio/SFX/Footsteps/Wood/Planks_1.wav"), preload("res://Audio/SFX/Footsteps/Wood/Planks_2.wav"), preload("res://Audio/SFX/Footsteps/Wood/Planks_3.wav"), preload("res://Audio/SFX/Footsteps/Wood/Planks_4.wav"), preload("res://Audio/SFX/Footsteps/Wood/Planks_5.wav"), preload("res://Audio/SFX/Footsteps/Wood/Planks_6.wav")]

#Interactions
@onready var interaction_ray_cast: RayCast3D = $Camera3D/InteractionRayCast


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	play_step_sound()
	move_and_slide()


func _process(delta: float) -> void:
	cam_bob(delta)
	if Input.is_action_just_pressed("interact"):
		var interactor = interaction_ray_cast.get_collider()
		if interactor != null and interactor.has_method("use"):
			print(interactor)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensetivity))
		camera_3d.rotate_x(deg_to_rad(-event.relative.y * mouse_sensetivity))
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-85), deg_to_rad(85))


func cam_bob(delta: float) -> void:
	_delta += delta
	
	var cam_bob
	var cambob_cam
	if direction != Vector3.ZERO:
		cam_bob = floor(abs(direction.z) + abs(direction.x)) * _delta * cambob_speed
		cambob_cam = camera_position + Vector3.UP * sin(cam_bob) * cambob_area
	else:
		cam_bob = floor(abs(1) + abs(1)) * _delta * cambob_speed_in_no_motion
		cambob_cam = camera_position + Vector3.UP * sin(cam_bob) * cambob_area_in_no_motion

	camera_3d.position = camera_3d.position.lerp(cambob_cam, delta)


func play_step_sound() -> void:
	if not is_on_floor():
		dist_travelled_since_last_step = 0.0
	
	dist_travelled_since_last_step += global_position.distance_to(last_pos)
	if dist_travelled_since_last_step >= step_after_dist:
		dist_travelled_since_last_step = 0.0
		step_player.stream = wooden_plank_audio.pick_random()
		step_player.pitch_scale = randf_range(.9, 1.1)
		step_player.play()
	
	last_pos = global_position
