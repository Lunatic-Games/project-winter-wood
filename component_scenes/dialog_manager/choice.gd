extends Button

var entry

onready var dialog_manager = get_tree().root.get_node("TestScene/DialogManager")

func setup(_entry):
	entry = _entry

func _on_Choice_pressed():
	dialog_manager.add_dialog(entry)
	get_parent().wipe_choices()
