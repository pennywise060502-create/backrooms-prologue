extends TextureRect

var frames = []
var current_frame = 0
var fps = 12.0
var timer = 0.0

func _ready():
	set_anchors_preset(Control.PRESET_FULL_RECT)
	position = Vector2.ZERO
	size = get_viewport_rect().size
	stretch_mode = TextureRect.STRETCH_SCALE

	for i in range(1, 121):
		var path = "res://opening_frames/opening_%03d.png" % i
		frames.append(load(path))

	texture = frames[0]

func _process(delta):
	position = Vector2.ZERO
	size = get_viewport_rect().size

	timer += delta

	if timer >= 1.0 / fps:
		timer = 0.0
		current_frame += 1

		if current_frame >= frames.size():
			current_frame = 0

		texture = frames[current_frame]
		
