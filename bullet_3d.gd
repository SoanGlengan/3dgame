extends Area3D

const SPEED = 3.0
const RANGE = 40.0

var travelledDistance = 0.0


func _physics_process(delta):
	position += transform.basis.x * SPEED * delta
	travelledDistance += SPEED * delta
	if travelledDistance > RANGE:
		queue_free()	
