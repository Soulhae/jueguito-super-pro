extends ProgressBar

func _ready():
	var player = get_tree().root.find_child("Player", true, false)
	if player:
		player.dash_state_changed.connect(_on_dash_changed)

func _on_dash_changed(is_ready: bool, time: float):
	var tween = create_tween()
	
	if not is_ready:
		value = 0
		tween.tween_property(self, "value", 100, time)
