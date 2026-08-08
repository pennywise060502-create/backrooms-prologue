extends CharacterBody2D

var speed = 300
var can_move = false

func _physics_process(delta):
	if not can_move:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var input_vector = Vector2.ZERO

	var horizontal = 0
	var vertical = 0

	# 오른쪽: 방향키 오른쪽 or D
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		horizontal += 1

	# 왼쪽: 방향키 왼쪽 or A
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		horizontal -= 1

	# 아래: 방향키 아래 or S
	if Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
		vertical += 1

	# 위: 방향키 위 or W
	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
		vertical -= 1

	# 대각선 이동 방지
	# 좌우 입력이 있으면 위아래 입력 무시
	if horizontal != 0:
		input_vector.x = horizontal
		input_vector.y = 0
	elif vertical != 0:
		input_vector.x = 0
		input_vector.y = vertical
	else:
		input_vector = Vector2.ZERO

	velocity = input_vector * speed
	move_and_slide()
