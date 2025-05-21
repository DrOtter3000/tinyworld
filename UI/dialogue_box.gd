extends ColorRect


@export var dialoguePath := ""
@export var sound := ""
@export var textSpeed := .03

var dialogue: Array

var phraseNumber := 0
var finished := false
signal has_finished

@onready var letter_sound: AudioStreamPlayer = $LetterSound
@onready var timer: Timer = $Timer


func _ready() -> void:
	if sound != "":
		letter_sound.stream  = load(sound)
		timer.wait_time = textSpeed
		
		dialogue = getDialogue()
		assert(dialogue, "Dialogue not found!")
		nextPhrase()
		


func getDialogue() -> Array:
	var f = FileAccess.open(dialoguePath, FileAccess.READ)
	assert(f.file_exists(dialoguePath), "file path doesn't exist!")
	
	var json = f.get_as_text()
	var output = JSON.parse_string(json)
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []


func nextPhrase():
	if phraseNumber >= len(dialogue):
		emit_signal("has_finished")
		queue_free()
		return
	
	finished = false
	$NameLabel.text = dialogue[phraseNumber]["Name"]
	$Text.bbcode_text = dialogue[phraseNumber]["Text"]
	$Text.visible_characters = 0
	while $Text.visible_characters < len($Text.text):
		$Text.visible_characters += 1
		letter_sound.pitch_scale = randf_range(.8, 1.2)
		letter_sound.play()
		await timer.timeout
	
	finished = true
	phraseNumber += 1
	return
