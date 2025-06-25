extends Node

@onready var prompt_panel: Panel = $Panel
@onready var input_field: LineEdit = $Panel/LineEdit

func _ready():
	# Hide prompt initially
	prompt_panel.hide()

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_E:
		open_prompt()  # Only open the prompt, do not close

func open_prompt():
	if not prompt_panel.visible:  # Only show if hidden
		await get_tree().create_timer(0.1).timeout  # Wait for 0.1 seconds before showing the prompt
		prompt_panel.show()
		input_field.grab_focus()  # Focus the input field
		input_field.text = ""  # Clear the input field immediately
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # Unlock mouse for input

func _on_submit_pressed():
	print("User entered:", input_field.text)
	prompt_panel.hide()
	input_field.text = ""  # Clear input
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Lock mouse back

func _on_button_pressed() -> void:
	_on_submit_pressed()  # Call the submit function when the button is pressed
