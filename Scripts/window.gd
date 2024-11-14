extends Camera2D


func _on_window_close_requested() -> void: $Window.hide()


func _on_medicines_slide_value_changed(value: float) -> void:
	print("Medicines level: %d\n" % value)
	





func _on_button_pressed() -> void:
	if not $Window.is_visible():
		$Window.show()
		$Window.grab_focus()  
