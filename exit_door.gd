extends Area2D


func _on_body_entered(body):
	get_tree().quit()
