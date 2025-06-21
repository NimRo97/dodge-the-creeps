extends CanvasLayer

signal start_game

func show_message(text) -> void:
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	await $MessageTimer.timeout

func show_game_over() -> void:
	await show_message("Game Over")
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score) -> void:
	$ScoreLabel.text = str(score)

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout() -> void:
	$Message.hide()
