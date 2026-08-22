extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_parent().process_mode = Node.PROCESS_MODE_DISABLED
		get_parent().visible = false
