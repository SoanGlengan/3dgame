extends Area3D

const SPEED = 30.0
const RANGE = 70.0

var travelledDistance = 0.0


func _physics_process(delta):
	position += transform.basis.x * SPEED * delta
	travelledDistance += SPEED * delta
	if travelledDistance > RANGE:
		queue_free()	

func _on_body_entered(body: Node3D) -> void:
	if body == CollisionShape3D:
		print("wow, i think i just collided with a player")
	queue_free()
