extends Interactor

var open := false
var interactable := true
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func use() -> void:
	if interactable:
		if open:
			animation_player.play("close")
			open = false
		else:
			animation_player.play("open")
			open = true
		interactable = false	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	interactable = true
