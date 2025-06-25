extends Node

@onready var text_edit: TextEdit = $"../CanvasLayer/TextEdit"
@onready var line_edit: LineEdit = $"../CanvasLayer/LineEdit"
@onready var read_input_and_write: Node = $"../Read Input and Write"

var _time_passed: float = 0.0
var _cached_content: String = ""
var file_location: String

func _ready() -> void:
	# Get full absolute path to res://
	var project_path = ProjectSettings.globalize_path("res://")
	
	# Manually strip the last 12 characters (e.g., "chat_to_npc/")
	var trimmed_path = project_path.substr(0, project_path.length() - 12)
	
	# Build final path to read/output.txt
	file_location = trimmed_path + "read/output.txt"
	print("Resolved file path: ", file_location)

	# Load initial content if available
	var file = FileAccess.open(file_location, FileAccess.READ)
	if file:
		_cached_content = file.get_as_text()
		file.close()
	else:
		push_error("Failed to open file: " + file_location)

func _process(delta: float) -> void:
	if read_input_and_write.input_inserted:
		_time_passed += delta
		if _time_passed >= 2.0:
			_time_passed = 0.0
			read_file()

func read_file() -> void:
	var file = FileAccess.open(file_location, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		if content != _cached_content:
			print(content)
			text_edit.text = content
			_cached_content = content
			line_edit.editable = true
		file.close()
	else:
		print("File not found: " + file_location)
