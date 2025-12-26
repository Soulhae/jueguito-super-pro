extends Area2D

@export var speed = 600

func _physics_process(delta):
	position.y += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("hp_loss"):
		body.hp_loss()
	queue_free()
