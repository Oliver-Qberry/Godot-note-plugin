@tool
extends Control


const NOTES_PATH := "res://addons/Notes/note.txt"

@onready var text_edit: TextEdit = $"VBoxContainer/TextEdit"
@onready var title: Label = $"VBoxContainer/Title"

func _ready():
	# Get the project name
	var project_name = ProjectSettings.get_setting("application/config/name")
	
	if project_name == "":
		# If no specific name is set in the project settings, it might default to the folder name 
		# or be empty. You can set it explicitly in Project Settings.
		project_name = "Unnamed Project"
		print("Failed to get project name from settings.")
	title.text = project_name

	text_edit.size_flags_vertical = SIZE_EXPAND_FILL
	text_edit.size_flags_horizontal = SIZE_EXPAND_FILL
	text_edit.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	#add_child(text_edit)

	#load_notes()
	text_edit.text = open_note(NOTES_PATH)

	text_edit.text_changed.connect(save_note)

func load_notes(): # FIXME: I think this crashed godot
	if FileAccess.file_exists(NOTES_PATH):
		var file := FileAccess.open(NOTES_PATH, FileAccess.READ)
		text_edit.text = file.get_as_text()

func save_note():
	var file := FileAccess.open(NOTES_PATH, FileAccess.WRITE)
	file.store_string(text_edit.text)
	file.close()


func open_note(path: String):
	if not FileAccess.file_exists(path):
		print("Note file does not exist: %s" % path)
		return ""

	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		print("Failed to open file: %s" % path)
		return ""

	var content: String = file.get_as_text()
	if content == null:
		print("Failed to read content from file: %s" % path)
		return ""

	file.close()
	return content

func _on_save_button_pressed() -> void:
	if not FileAccess.file_exists(NOTES_PATH):
		print("Note file does not exist: %s" % NOTES_PATH)
		pass
	else:
		save_note()
