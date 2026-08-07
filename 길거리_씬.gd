extends Node2D

@onready var intro_camera = $IntroCamera
@onready var player_camera = $player/Camera2D
@onready var player = $player

@onready var manhole = $맨홀
@onready var manhole_lid = $맨홀/Sprite2D
@onready var black_hole = $맨홀/구멍

@onready var dialogue_ui = $대화창
@onready var dialogue_box = $대화창/Panel
@onready var dialogue_text = $대화창/Panel/대사
@onready var next_label = $"대화창/Panel/다음 대사"
@onready var fade_black = $대화창/FadeBlack

var dialogues = [
	"와... 벌써 12시네.",
	"빨리 집 가야겠다...",
	"오늘따라 길이 왜 이렇게 조용하지?"
]

var dialogue_index = 0
var dialogue_active = false
var next_label_tween
var falling_started = false


func _ready():
	player.can_move = false

	# 대화창 준비
	dialogue_ui.visible = true
	dialogue_box.visible = false

	# 맨홀 상태 준비
	manhole_lid.visible = true
	black_hole.visible = false

	# 페이드 검은 화면 준비
	fade_black.visible = false
	fade_black.color = Color.BLACK
	fade_black.modulate.a = 0.0
	fade_black.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# 처음에는 인트로 카메라 사용
	intro_camera.enabled = true
	player_camera.enabled = false

	# 하늘 쪽에서 시작
	intro_camera.global_position = Vector2(944, -750)

	var tween = create_tween()

	# 카메라가 천천히 플레이어 위치로 내려옴
	tween.tween_property(
		intro_camera,
		"global_position",
		Vector2(944, 652),
		8.0
	)

	await tween.finished

	# 플레이어 카메라로 전환
	intro_camera.enabled = false
	player_camera.enabled = true

	# 시작 대사
	start_dialogue()


func _process(delta):
	# 이미 떨어지는 이벤트가 시작됐으면 아무것도 안 함
	if falling_started:
		return

	# 플레이어가 아직 움직이는 상태가 아니면 체크 안 함
	if not player.can_move:
		return

	# 플레이어가 맨홀 x 위치에 도착하면 이벤트 시작
	if player.global_position.x >= manhole.global_position.x - 20:
		falling_started = true
		print("맨홀 위치 도착")
		start_manhole_event()


func start_dialogue():
	dialogue_active = true
	dialogue_index = 0

	dialogue_box.visible = true
	dialogue_text.text = dialogues[dialogue_index]
	next_label.visible = true
	next_label.text = "- SPACE -"

	animate_next_label()


func _input(event):
	if dialogue_active:
		if event.is_action_pressed("ui_accept"):
			next_dialogue()


func next_dialogue():
	dialogue_index += 1

	if dialogue_index < dialogues.size():
		dialogue_text.text = dialogues[dialogue_index]
	else:
		dialogue_box.visible = false
		dialogue_active = false

		if next_label_tween:
			next_label_tween.kill()

		player.can_move = true


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


func start_manhole_event():
	# 캐릭터 멈춤
	player.can_move = false
	player.velocity = Vector2.ZERO

	# SPACE 표시 멈추고 숨김
	if next_label_tween:
		next_label_tween.kill()

	next_label.visible = false

	# 첫 번째 자동 대사
	dialogue_box.visible = true
	dialogue_text.text = "어...?"

	await get_tree().create_timer(2.0).timeout

	# 1.2초 뒤 동시에 발생
	shake_camera()

	manhole_lid.visible = false
	black_hole.visible = true

	player.visible = false

	dialogue_text.text = "으아아아아아아!!"

	await get_tree().create_timer(2.5).timeout

	# 대사창 사라짐
	dialogue_box.visible = false

	# 화면 검게 페이드아웃
	fade_black.visible = true
	fade_black.modulate.a = 0.0

	var fade_tween = create_tween()
	fade_tween.tween_property(
		fade_black,
		"modulate:a",
		1.0,
		2.0
	)

	await fade_tween.finished

	print("다음 씬으로 이동")

	# Backrooms 씬 만들면 위 print 지우고 이걸 켜면 됨
	# get_tree().change_scene_to_file("res://backrooms.tscn")


func shake_camera():
	var original_offset = player_camera.offset

	var shake = create_tween()

	shake.tween_property(player_camera, "offset", Vector2(18, -10), 0.05)
	shake.tween_property(player_camera, "offset", Vector2(-18, 10), 0.05)
	shake.tween_property(player_camera, "offset", Vector2(14, 8), 0.05)
	shake.tween_property(player_camera, "offset", Vector2(-14, -8), 0.05)
	shake.tween_property(player_camera, "offset", Vector2(10, -6), 0.05)
	shake.tween_property(player_camera, "offset", original_offset, 0.05)
	
