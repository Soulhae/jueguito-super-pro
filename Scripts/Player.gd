extends CharacterBody2D

var speed = 250
@export var bulletScene: PackedScene
var dodge_duration = 0.75
var dodge_cooldown = 2
var can_dodge = true
var is_dodging = false

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
	if dashing and can_dodge:
		start_dodge()
	
	var shooting = Input.is_action_just_pressed("test")
	if shooting:
		var bullet = bulletScene.instantiate()
		bullet.position.x = position.x
		bullet.position.y = position.y + 32
		get_parent().add_child(bullet)
		
	position.x = clamp(position.x, 0, get_viewport_rect().size.x)
	position.y = clamp(position.y, 0, get_viewport_rect().size.y)


func start_dodge():
	can_dodge = false
	is_dodging = true
	
	set_collision_layer_value(1, false)
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property($Sprite2D,"scale",Vector2(0.75,0.75), 0.1)
	tween.tween_property($Sprite2D,"modulate",Color(0.5,0.5,0.5,0.995),0.1)
	
	await get_tree().create_timer(dodge_duration).timeout
	end_dodge()


func end_dodge():
	is_dodging = false
	
	set_collision_layer_value(1, true)
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property($Sprite2D, "scale", Vector2(1.0, 1.0), 0.1)
	tween.tween_property($Sprite2D, "modulate", Color(1, 1, 1, 1), 0.1)
	
	await get_tree().create_timer(dodge_cooldown).timeout
	can_dodge = true
