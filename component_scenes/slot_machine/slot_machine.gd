extends Control

@export var equipment: Resource
@export var frame_scene: PackedScene

const frame_size = 48
const frame_seperation = 2

@onready var frames_container = $FramesContainer
@onready var border_node = $SlotMachineBorder
@onready var background_node = $SlotMachineBackground
@onready var full_disabler = $FullDisabler
@onready var enemy_disabler = $EnemyDisabler
@onready var used_disabler = $UsedDisabler

var frames = []
var active_frames = []
var frames_rolling = 0
var owner_of_slot_machine

signal attempting_to_acquire_target
signal slot_machine_finished_rolling

#func _ready():
#	setup(equipment)
func setup(equipment, _owner, owned_by_enemy = false):
	owner_of_slot_machine = _owner
	
	# For each column in the equipment create a frame
	for column in equipment.columns:
		var frame = frame_scene.instance()
		frames_container.add_child(frame)
		frame.setup(equipment.faces[column], true)
		frame.connect("finished_rolling", self, "handle_frame_finished_rolling")
	
	frames = frames_container.get_children()
	
	# Set the width of the border to encapsulate the frames
	if frames_container.get_child_count() >= 4:
		border_node.rect_size.x += (frame_size + frame_seperation)*(frames_container.get_child_count()-3)
		background_node.rect_size.x += (frame_size + frame_seperation)*(frames_container.get_child_count()-3)
		# Set the width of the disablers
		full_disabler.get_child(1).rect_size.x += (frame_size + frame_seperation)*(frames_container.get_child_count()-3)
		enemy_disabler.get_child(1).rect_size.x += (frame_size + frame_seperation)*(frames_container.get_child_count()-3)
		
	if owned_by_enemy:
		enemy_disabler.visible = true


func _on_SlotMachineButton_pressed():
	spin_nonlocked_frames()

func spin_nonlocked_frames():
	for frame in frames:
		frame.start_spinning()
		frames_rolling += 1
		await get_tree().create_timer(0.35).timeout
	

func handle_frame_finished_rolling():
	frames_rolling -= 1
	
	if frames_rolling == 0:
		emit_signal("slot_machine_finished_rolling", self)

func _on_ExecuteResultsButton_pressed():
	fully_disable()
	emit_signal("attempting_to_acquire_target", self)

func fully_disable():
	full_disabler.visible = true

func fully_enable():
	full_disabler.visible = false

func refresh():
	used_disabler.visible = false
	spin_nonlocked_frames()

# TODO: Refactor this code specifically, applying statuses and damage
func execute_on_target(target):
	var face_data
	var total_damage = 0
	# Loop over all faces and do the following
	for frame in frames:
	# Check if the requirement is met
	# Calculate the damage
		face_data = frame.get_active_frame_data()
		var effect_index = 0
		for effect in face_data.effects:
			total_damage += effect.effect_script.get_damage(face_data.effects_weights[effect_index])
			if effect.apply_to_target:
				target.apply_status(effect, face_data.effects_weights[effect_index])
			if effect.apply_to_self:
				owner_of_slot_machine.apply_status(effect, face_data.effects_weights[effect_index])
			effect_index += 1
	target.take_damage(total_damage)
	used_disabler.visible = true

func get_frame_statuses():
	var face_data
	var all_frame_data = []
	for frame in frames:
		face_data = frame.get_active_frame_data()
		all_frame_data.append(face_data)
	
	return all_frame_data
