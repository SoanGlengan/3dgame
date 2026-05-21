extends CharacterBody3D

var ammo = 16
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var timeSinceLastShoot = 0

@onready var neck := $Neck
@onready var camera := $Neck/Camera3D



func _enter_tree():
	set_multiplayer_authority(name.to_int())
	
func _ready():
	camera.current = is_multiplayer_authority()

func _process(delta: float) -> void:
	timeSinceLastShoot += 1 
	

func _unhandled_input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		if event is InputEventMouseButton:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		elif event.is_action_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			if event is InputEventMouseMotion:
				neck.rotate_y(-event.relative.x * 0.001)
				camera.rotate_x(-event.relative.y * 0.001)
				camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(90))
		if Input.is_action_pressed("shoot") and timeSinceLastShoot > 15:
			shoot_bullet()
			timeSinceLastShoot = 0
		if Input.is_action_just_pressed("exit"):
			$"../".exit_game(name.to_int())
			get_tree().quit()
func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		if not is_on_floor():
			velocity += get_gravity() * delta
		
			

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("left", "right", "forward", "back")
		var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		

		move_and_slide()
	

func shoot_bullet():
	const BULLET_3D = preload("res://bullet_3d.tscn")
	var new_bullet = BULLET_3D.instantiate()
	new_bullet.position = $Neck/Camera3D/Marker3D.global_position
	new_bullet.rotation = $Neck/Camera3D/Marker3D.global_rotation
	add_child(new_bullet)
	ammo -= 1
	
