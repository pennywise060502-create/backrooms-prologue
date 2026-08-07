extends Control

func _on_게임_시작_글_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print("START 클릭됨")
			get_tree().change_scene_to_file("res://길거리 씬.tscn")


func _on_스타트_버튼_pressed() -> void:
	print("START 버튼 눌림")
	get_tree().change_scene_to_file("res://길거리 씬.tscn")
