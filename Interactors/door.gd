extends Interactor

var open := false
var interactable := true
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	set_door_text()


func use() -> void:
	if interactable:
		if open:
			open = false
			animation_player.play("close")
		else:
			open = true
			animation_player.play("open")
		interactable = false
		set_door_text()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	interactable = true


func set_door_text():
	if open:
		prompt = "close door"
	else:
		prompt = "open door"
