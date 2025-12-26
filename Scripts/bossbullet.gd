extends Area2D

@export var speed = 400
@export var damage_amount = 25
var direction = Vector2.UP

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage_amount)
	queue_free()
