extends CharacterBody2D

@export var speed = 250
@export var hp = 500

func _init():
	position.x = 324
	position.y = 800

func _physics_process(_delta: float) -> void:
	pass

func hp_loss():
	hp -= 100
	if hp==0:
		queue_free()
