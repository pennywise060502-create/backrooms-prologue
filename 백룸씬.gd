extends Node2D

@onready var player = $player
@onready var player_camera = $player/Camera2D

@onready var dialogue_ui = $대화창
@onready var dialogue_box = $대화창/Panel
@onready var dialogue_text = $대화창/Panel/대사
@onready var next_label = $"대화창/Panel/다음 대사"
@onready var fade_black = $대화창/FadeBlack

var next_label_tween


func _ready():
	# 처음에는 못 움직이게
	player.can_move = false
	
	# 캐릭터 누워있는 상태
	player.rotation_degrees = 90
	
	# 카메라 켜기
	player_camera.enabled = true
	
	# 대화창 준비
	dialogue_ui.visible = true
	dialogue_box.visible = false
	next_label.visible = false
	
	# 검은 화면으로 시작
	fade_black.visible = true
	fade_black.color = Color.BLACK
	fade_black.modulate.a = 1.0
	
	# 화면 천천히 밝아짐
	var fade_tween = create_tween()
	fade_tween.tween_property(
		fade_black,
		"modulate:a",
		0.0,
		2.0
	)
	
	await fade_tween.finished
	
	fade_black.visible = false
	
	# 첫 대사
	dialogue_box.visible = true
	dialogue_text.text = "으..윽............................"
	next_label.visible = false
	
	await get_tree().create_timer(1.3).timeout
	
	# 캐릭터 일어나는 연출
	var stand_tween = create_tween()
	stand_tween.tween_property(
		player,
		"rotation_degrees",
		0,
		1.2
	)
	
	await stand_tween.finished
	
	# 두 번째 대사
	dialogue_text.text = "여긴..... 어디야?"
	next_label.visible = true
	next_label.text = "- SPACE -"
	
	animate_next_label()
	
	# 여기서는 플레이어가 SPACE 눌러야 넘어가게 함
	await wait_for_space()
	
	# 대사창 사라짐
	if next_label_tween:
		next_label_tween.kill()
	
	dialogue_box.visible = false
	next_label.visible = false
	
	# 이제 움직임 가능
	player.can_move = true


func wait_for_space():
	while true:
		await get_tree().process_frame
		
		if Input.is_action_just_pressed("ui_accept") or Input.is_key_pressed(KEY_SPACE):
			break


func animate_next_label():
	if next_label_tween:
		next_label_tween.kill()
	
	next_label.modulate.a = 1.0
	
	var original_pos = next_label.position
	
	next_label_tween = create_tween()
	next_label_tween.set_loops()
	
	next_label_tween.tween_property(
		next_label,
		"position",
		original_pos + Vector2(0, -8),
		0.45
	)
	
	next_label_tween.parallel().tween_property(
		next_label,
		"modulate:a",
		0.35,
		0.45
	)
	
	next_label_tween.tween_property(
		next_label,
		"position",
		original_pos,
		0.45
	)
	
	next_label_tween.parallel().tween_property(
		next_label,
		"modulate:a",
		1.0,
		0.45
	)
