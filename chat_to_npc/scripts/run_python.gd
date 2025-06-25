extends Node

var thread: Thread = null
@onready var read_input_and_write: Node = $"../Read Input and Write"

func _ready() -> void:
	check_input_and_start_thread()

func _process(_delta: float) -> void:
	check_input_and_start_thread()

func _exit_tree() -> void:
	if thread != null and thread.is_started():
		thread.wait_to_finish()

func check_input_and_start_thread() -> void:
	if read_input_and_write.input_inserted:
		if thread == null or not thread.is_started():
			thread = Thread.new()
			thread.start(Callable(self, "execute_python_script"), Thread.PRIORITY_LOW)

func execute_python_script() -> void:
	var path = "python"
	var arguments = PackedStringArray(["run.py"])
	var output = []
	OS.execute(path, arguments, output, true)
