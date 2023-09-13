extends CanvasLayer

const dialog_entry_scene = preload("res://component_scenes/dialog_manager/dialog_entry.tscn")
const portrait_scene = preload("res://component_scenes/dialog_manager/portrait.tscn")
const progress_dialog_scene = preload("res://component_scenes/dialog_manager/progress_dialog_hint.tscn")
const choice_entry_scene = preload("res://component_scenes/dialog_manager/choice_entry.tscn")

onready var animator = $AnimationPlayer
onready var dialog_container = $Panel/ScrollContainer/DisplayContainer
onready var player = get_tree().root.get_node("TestScene/YSort/Player")

func enter_dialog():
	animator.play("enter")
	yield(animator, "animation_finished")

func leave_dialog():
	animator.play("exit")

func setup(dialog_entry_point):
	wipe_dialog_container()
	yield(enter_dialog(), "completed")
	if dialog_entry_point.portrait != null:
		pass
	
	add_dialog(dialog_entry_point)

func wipe_dialog_container():
	for child in dialog_container.get_children():
		child.queue_free()

func add_dialog(_dialog_entry):
	if _dialog_entry == null:
		return
	
	if _dialog_entry.portrait != null:
		var portrait = portrait_scene.instance()
		portrait.texture = _dialog_entry.portrait
		dialog_container.add_child(portrait)
		yield(get_tree().create_timer(0.2), "timeout")
	
	if _dialog_entry.type == _dialog_entry.DIALOG_TYPES.dialog:
		var dialog_entry = dialog_entry_scene.instance()
		dialog_entry.bbcode_text = _dialog_entry.text
		dialog_container.add_child(dialog_entry)
	
		if _dialog_entry.entry_references.size() > 0:
			add_progress_dialog_hint()
			yield(player, "progress_dialog")
			remove_progress_dialog_hint()
			add_dialog(_dialog_entry.entry_references[0])
	
	if _dialog_entry.type == _dialog_entry.DIALOG_TYPES.choice:
		var choice_entry = choice_entry_scene.instance()
		dialog_container.add_child(choice_entry)
		choice_entry.setup(_dialog_entry.choices)


func add_progress_dialog_hint():
	var progress_dialog = progress_dialog_scene.instance()
	dialog_container.add_child(progress_dialog)


func remove_progress_dialog_hint():
	dialog_container.get_child(dialog_container.get_child_count()-1).queue_free()
