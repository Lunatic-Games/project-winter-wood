extends CharacterBody2D

var movespeed = 100
var interactables = []
var interacting = false

signal progress_dialog

func _physics_process(delta):
	if interacting:
		handle_interaction_controls()
	else:
		handle_movement(delta)

func handle_movement(delta):
	var direction = Vector2(0, 0)
	
	if Input.is_action_just_pressed("interact"):
		handle_interact()
	
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("up"):
		direction.y -= 1
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1

	direction = direction.normalized()
	
	if direction.x < 0:
		$Sprite.flip_h = true
	if direction.x > 0:
		$Sprite.flip_h = false
	
	move_and_collide(direction * movespeed * delta)

func handle_interaction_controls():
	if Input.is_action_just_pressed("interact"):
		emit_signal("progress_dialog")

func handle_interact():
	if interactables.size() > 0:
		interactables[0].interact()
		interacting = true


func _on_InteractFindingZone_area_entered(area):
	print(area.get_parent().name)
	
	if !interactables.size() > 0:
		area.get_parent().set_interactable(true)
	interactables.append(area.get_parent())


func _on_InteractFindingZone_area_exited(area):
	# If the button is displaying stop displaying it.
	if area.get_parent() == interactables[0]:
		area.get_parent().set_interactable(false)
	
	interactables.erase(area.get_parent())
	
	if interactables.size() > 0:
		interactables[0].set_interactable(true)
