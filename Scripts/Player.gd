extends CharacterBody2D

@export var speed = 250
@export var bulletScene: PackedScene

func _init():
	position.x = 324
	position.y = 64

func _physics_process(_delta: float) -> void:
	var moving = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if moving:
		velocity = moving * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	
	var dashing = Input.is_action_just_pressed("dash")
	if dashing:
		position += velocity * 0.35
	
	var shooting = Input.is_action_just_pressed("test")
	if shooting:
		var bullet = bulletScene.instantiate()
		bullet.position.x = position.x
		bullet.position.y = position.y + 32
		get_parent().add_child(bullet)
		
	
	position.x = clamp(position.x, 0, get_viewport_rect().size.x)
	position.y = clamp(position.y, 0, get_viewport_rect().size.y)
