extends CharacterBody2D

var speed = 250
var hp: int = 5000
@export var bulletScene: PackedScene

func _init():
	position.x = 768
	position.y = 800

func _physics_process(_delta: float) -> void:
	pass

func hp_loss():
	hp -= 100
	if hp==0:
		queue_free()
