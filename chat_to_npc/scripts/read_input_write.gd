extends Node

@onready var text_edit: TextEdit = $"../CanvasLayer/TextEdit"
@onready var line_edit: LineEdit = $"../CanvasLayer/LineEdit"

var entered_text: String = ""
var input_inserted: bool = false
var file_location: String

func _ready() -> void:
	# Resolve working directory by removing last 12 characters from the project path
	var project_path = ProjectSettings.globalize_path("res://")
	var trimmed_path = project_path.substr(0, project_path.length() - 12)
	file_location = trimmed_path + "read/input.txt"
	
	print("Resolved input file path: ", file_location)
	
	line_edit.connect("text_submitted", Callable(self, "_on_text_entered"))

func _process(_delta: float) -> void:
	pass

func _on_text_entered(new_text: String) -> void:
	entered_text = new_text
	input_inserted = true
	write_to_file(entered_text)
	line_edit.text = ""  # Clear the LineEdit
	line_edit.editable = false
	text_edit.text = entered_text  # Display entered text

func write_to_file(text: String) -> void:
	var file = FileAccess.open(file_location, FileAccess.WRITE)
	if file:
		file.store_string(text)
		file.close()
	else:
		print("Failed to open file for writing: " + file_location)
