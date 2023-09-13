extends Node2D

export (Resource) var dialog_entry_point

onready var interaction_animator = $InteractionAnimationPlayer
onready var dialog_manager = get_tree().root.get_node("TestScene/DialogManager")

func set_interactable(is_interactable):
	if is_interactable:
		interaction_animator.play("interactionIn")
	
	if !is_interactable:
		interaction_animator.play("interactionOut")

func interact():
	dialog_manager.setup(dialog_entry_point)
	
	
