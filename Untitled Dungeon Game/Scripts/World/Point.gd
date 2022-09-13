extends StaticBody


func _on_Collect_body_entered(body):
	GameController.updateScore()
	queue_free()
