extends CharacterBody2D

var speed = 250
var hp: int = 5000
var current_angle: float = 0.0
@export var bulletScene: PackedScene
@onready var anim_player = $AnimationPlayer

func _init():
	position.x = 768
	position.y = 800

func _ready():
	await get_tree().create_timer(2).timeout
	var random_int_range = randi_range(0, 1)
	if random_int_range == 0:
		for i in range(10):
			anim_player.play("test_attack")
			await anim_player.animation_finished
	else:
		spawn_bullet_metralleta()

func _physics_process(_delta: float) -> void:
	pass
	
func spawn_bullet_circle():
	var total_bullets = 36
	var angle_step = TAU / total_bullets
	
	for i in range(total_bullets):
		var bullet = bulletScene.instantiate()
		
		bullet.global_position = global_position
		
		current_angle = angle_step * i
		
		var dir_vector = Vector2.RIGHT.rotated(current_angle)
		
		bullet.direction = dir_vector
		bullet.rotation = current_angle
		
		get_parent().add_child(bullet)


func spawn_bullet_metralleta():
	current_angle = -45.0
	anim_player.play("charge")
	await anim_player.animation_finished
	
	var aim_tween = create_tween()
	aim_tween.set_loops()
	aim_tween.set_trans(Tween.TRANS_SINE)
	
	aim_tween.tween_property(self,"current_angle",45.0,0.5)
	aim_tween.tween_property(self,"current_angle",-45.0,0.5)
	
	var attack_duration = 2
	var time_passed = 0.0
	var fire_rate = 0.03
	
	while time_passed<attack_duration:
		if hp<=0: return
		
		var bullet = bulletScene.instantiate()
		bullet.global_position = global_position
		var dir_vector = Vector2.UP.rotated(deg_to_rad(current_angle))
		
		bullet.direction = dir_vector
		bullet.rotation = dir_vector.angle()
		
		get_parent().add_child(bullet)
		await get_tree().create_timer(fire_rate).timeout
		time_passed += fire_rate
		
	aim_tween.kill()


func hp_loss():
	hp -= 100
	if hp==0:
		queue_free()
