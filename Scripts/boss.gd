extends CharacterBody2D

var speed = 250
var hp: int = 5000
@export var bulletScene: PackedScene
@onready var anim_player = $AnimationPlayer

func _init():
	position.x = 768
	position.y = 800

func _physics_process(_delta: float) -> void:
	await get_tree().create_timer(4).timeout
	anim_player.play("test_attack")
	
func spawn_bullet_circle():
	var total_bullets = 12
	var angle_step = TAU / total_bullets
	
	for i in range(total_bullets):
		var bullet = bulletScene.instantiate()
		
		bullet.global_position = global_position
		
		var current_angle = angle_step * i
		
		var dir_vector = Vector2.RIGHT.rotated(current_angle)
		
		bullet.direction = dir_vector
		bullet.rotation = current_angle
		
		get_parent().add_child(bullet)

func hp_loss():
	hp -= 100
	if hp==0:
		queue_free()
