extends CharacterBody2D

var speed = 250
var max_hp: int = 100
var current_hp: int
@export var bulletScene: PackedScene
@export var dodge_duration = 0.75
@export var dodge_cooldown = 2
var can_dodge = true
var is_dodging = false


signal dash_state_changed(is_ready, duration)

func _init():
	position.x = 768
	position.y = 64


func _ready():
	current_hp = max_hp


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
	if shooting and !is_dodging:
		var bullet = bulletScene.instantiate()
		bullet.position.x = position.x
		bullet.position.y = position.y + 32
		get_parent().add_child(bullet)
	
	var half_width = $Sprite2D.get_rect().size.x * scale.x / 2
	var half_height = $Sprite2D.get_rect().size.y * scale.y / 2
	var min_x = GameManager.PLAYFIELD_MARGIN_LEFT + half_width
	var max_x = GameManager.PLAYFIELD_MARGIN_RIGHT - half_width
	position.x = clamp(position.x, min_x, max_x)
	position.y = clamp(position.y, 0 + half_height, get_viewport_rect().size.y - half_height)


func start_dodge():
	can_dodge = false
	is_dodging = true
	
	dash_state_changed.emit(false, dodge_duration + dodge_cooldown) # Esto es para el UI
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(2, false)
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property($Sprite2D,"scale",Vector2(0.75,0.75), 0.1)
	tween.tween_property($Sprite2D,"modulate",Color(0.5,0.5,0.5,0.995),0.1)
	
	await get_tree().create_timer(dodge_duration).timeout
	end_dodge()


func end_dodge():
	is_dodging = false
	
	set_collision_layer_value(1, true)
	set_collision_mask_value(2, true)
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property($Sprite2D, "scale", Vector2(1.0, 1.0), 0.1)
	tween.tween_property($Sprite2D, "modulate", Color(1, 1, 1, 1), 0.1)
	
	await get_tree().create_timer(dodge_cooldown).timeout
	can_dodge = true


func take_damage(amount: int) -> void:
	if is_dodging:
		return
	
	current_hp -= amount
	if current_hp < 0:
		current_hp = 0
	
	if current_hp == 0:
		queue_free()
	
