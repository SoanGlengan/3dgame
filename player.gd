extends CharacterBody3D

var ammo = 16
const SPEED = 6.0
const JUMP_VELOCITY = 4.5
var timeSinceLastShoot = 0
var health = 100

@onready var playerName = $Camera3D/UserInterface/Name
@onready var camera := $Camera3D
@onready var name_tag: Label3D = $NameTag



func _enter_tree():
	set_multiplayer_authority(name.to_int())
	
func _ready():
	camera.current = is_multiplayer_authority()
	print(name)

func set_character_name(new_name: String) -> void:
	name_tag.set_text(new_name)

func _process(delta: float) -> void:
	timeSinceLastShoot += 1 
	if is_multiplayer_authority(): $Camera3D/UserInterface/ProgressBar.value = health
	
	if name_tag.text != playerName.text && is_multiplayer_authority():
		name_tag.set_text(playerName.text)
	
	if health <= 0 && is_multiplayer_authority():
		$"../".exit_game(name.to_int())
		
	

func _unhandled_input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		if event is InputEventMouseButton:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		elif event.is_action_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			if event is InputEventMouseMotion:
				rotate_y(-event.relative.x * 0.001)
				camera.rotate_x(-event.relative.y * 0.001)
				camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(90))
				
		
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
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			
		if Input.is_key_pressed(KEY_R):
			global_position = Vector3(0,1,0)
	
		if Input.is_action_pressed("shoot") and timeSinceLastShoot > 15:
			shoot_bullet.rpc()
			timeSinceLastShoot = 0
		if Input.is_action_just_pressed("exit"):
			$"../".exit_game(name.to_int())
			get_tree().quit()
		if velocity != Vector3(0,0,0):
			$WalkParticles.emitting = true
		else:
			$WalkParticles.emitting = false
				
		

		move_and_slide()
	
func recieve_damage(amount: int):
	health -= amount
	print("took damage current health: ", health)
	
	if health <= 0:
		print("bro really died")
		queue_free()
		
@rpc("any_peer", "call_local", "reliable")
func shoot_bullet():
	# Only the server handles hit registration to prevent cheating
	if not multiplayer.is_server():
		return
	
	$Camera3D/RayCast3D.force_raycast_update()
	print("shooting")
	# Check if the center crosshair raycast hit an enemy
	if $Camera3D/RayCast3D.is_colliding():
		print("dofaj kjfk")

	
