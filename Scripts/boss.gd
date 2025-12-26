extends CharacterBody2D

var speed = 250
var hp: int = 5000
var current_angle: float = 0.0
@export var bulletScene: PackedScene
@onready var anim_player = $AnimationPlayer
var attack_duration: int
var time_passed: float
var fire_rate: float
var boss_paths: Array = []

func _init():
	position.x = 768
	position.y = 800

func _ready():
	boss_paths = get_tree().get_nodes_in_group("boss_paths")
	await get_tree().create_timer(2).timeout
	decide_next_action()
	#var random_int_range = randi_range(0, 1)
	#var random_int_range = 0
	#if random_int_range == 0:
		#spawn_bullet_circle()
	#else:
		#spawn_bullet_metralleta()

func _physics_process(_delta: float) -> void:
	pass
	
func spawn_bullet_circle():
	var total_bullets = 36
	var angle_step = TAU / total_bullets
	
	attack_duration = 1
	time_passed = 0.0
	fire_rate = 0.25
	
	while time_passed<attack_duration:
		#anim_player.play_section("test_attack",0,0.6)
		#await anim_player.animation_finished
		for i in range(total_bullets):
			var bullet = bulletScene.instantiate()
			
			bullet.global_position = global_position
			
			current_angle = angle_step * i
			
			var dir_vector = Vector2.RIGHT.rotated(current_angle)
			
			bullet.direction = dir_vector
			bullet.rotation = current_angle
			
			get_parent().add_child(bullet)
		#anim_player.play_section("test_attack",0.6,1)
		#await anim_player.animation_finished
		await get_tree().create_timer(fire_rate).timeout
		time_passed += fire_rate
	finish_action()


func spawn_bullet_metralleta():
	current_angle = -45.0
	anim_player.play("charge")
	await anim_player.animation_finished
	
	var aim_tween = create_tween()
	aim_tween.set_loops()
	aim_tween.set_trans(Tween.TRANS_SINE)
	
	aim_tween.tween_property(self,"current_angle",45.0,0.5)
	aim_tween.tween_property(self,"current_angle",-45.0,0.5)
	
	attack_duration = 2
	time_passed = 0.0
	fire_rate = 0.03
	
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
	finish_action()


func hp_loss():
	hp -= 100
	if hp<=0:
		queue_free()


func decide_next_action():
	if hp<=0: return
	
	var option = randi_range(0,2)
	match option:
		0:
			move_by_path()
		1:
			spawn_bullet_circle()
		2:
			spawn_bullet_metralleta()


func move_by_path():
	var chosen_path: Path2D = boss_paths.pick_random()
	var curve = chosen_path.curve
	
	var start_point_local = curve.get_point_position(0)
	var start_point_global = chosen_path.to_global(start_point_local)
	var dist_to_start = global_position.distance_to(start_point_global)
	var approach_time = dist_to_start / speed
	
	var approach_tween = create_tween()
	if approach_time < 0.1: approach_time = 0.1
	approach_tween.tween_property(self, "global_position", start_point_global, approach_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await approach_tween.finished
	
	var tween = create_tween()
	var duration = 3
	
	tween.tween_method(func(offset): global_position = chosen_path.to_global(curve.sample_baked(offset)), 0.0, curve.get_baked_length(), duration).set_trans(Tween.TRANS_SINE)
	await tween.finished
	finish_action()


func finish_action():
	var cooldown = randf_range(0.75,2.5)
	await get_tree().create_timer(cooldown).timeout
	decide_next_action()
