extends CharacterBody2D

var speed = 100
var can_move = false

func _physics_process(delta):
	if not can_move:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	velocity.x = speed
	velocity.y = 0
	move_and_slide()
