extends CharacterBody2D

var speed = 200

func _physics_process(delta):
	var direction = Vector2.ZERO

	if Input.is_key_pressed(KEY_RIGHT):
		direction.x = 1
	elif Input.is_key_pressed(KEY_LEFT):
		direction.x = -1
	elif Input.is_key_pressed(KEY_DOWN):
		direction.y = 1
	elif Input.is_key_pressed(KEY_UP):
		direction.y = -1

	velocity = direction * speed
	move_and_slide()
