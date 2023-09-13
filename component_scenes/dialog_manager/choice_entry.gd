extends VBoxContainer

const choice_scene = preload("res://component_scenes/dialog_manager/choice.tscn")

func setup(choices):
	for entry in choices:
		var choice = choice_scene.instance()
		choice.text = entry.short_text
		add_child(choice)
		choice.setup(entry)

func wipe_choices():
	for child in get_children():
		child.queue_free()
