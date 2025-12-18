@tool
extends EditorPlugin

var dock

"""func _enable_plugin() -> void:
	# Add autoloads here.
	pass
func _disable_plugin() -> void:
	# Remove autoloads here.
	pass"""

#TODO: add the name of the current project above the text area
func _enter_tree() -> void:
	dock = preload("res://addons/Notes/notes_plugin_control.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, dock) # TODO: add it to the right hand panel
	#dock.request_open_note.connect(_open_note_in_editor)


func _exit_tree() -> void:
	if dock:
		remove_control_from_bottom_panel(dock)
		dock.free()
		dock = null


func _open_note_in_editor(note_path: String) -> void:
	var ei := get_editor_interface()
	ei.open_scene_from_path(note_path)
	# optional: highlight in FileSystem dock
	var fsd := ei.get_file_system_dock()
	if fsd:
		fsd.navigate_to_path(note_path)