extends CharacterBody2D

@onready var collissionShape = $CollisionShape2D
@onready var doctorSprite = $DoctorSprite
@onready var gameNode = get_tree().get_nodes_in_group("gameNode").front()
const SPEED = 300.0

const UP = 0
const RIGHT = 2
const DOWN = 4
const LEFT = 6

var hasBaby : bool = false

var objectInteracting = null
var babiesDelivered = 0;

func _physics_process(_delta):
	_handle_input()
	_set_animation_frame()	
	_perform_action()
	move_and_slide()

func _handle_input():
	var h_direction = Input.get_axis("Left", "Right")
	var v_direction = Input.get_axis("Up", "Down")
	if h_direction:
		velocity.x = h_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if v_direction:
		velocity.y = v_direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

func _perform_action():
	var actionPressed : bool = Input.is_action_just_pressed("Action")
	gameNode.set_action_label("")
	if(objectInteracting != null && objectInteracting.has_method("execute_action")):
		if(actionPressed):
			var baby = objectInteracting.execute_action(hasBaby)
			if(baby == "baby"):
				hasBaby = true
			elif(baby == "baby_bed"):
				hasBaby = false				
		else:
			gameNode.set_action_label(objectInteracting.get_text(hasBaby))			


func _set_animation_frame():
	# Down is the idle frame
	doctorSprite.frame = DOWN
	if(velocity.x > 0):
		doctorSprite.frame = RIGHT
	elif(velocity.x < 0):
		doctorSprite.frame = LEFT
	if(velocity.y < 0):
		doctorSprite.frame = UP
	elif(velocity.y > 0):
		doctorSprite.frame = DOWN
	
	if(hasBaby):
		doctorSprite.frame +=1
	

func _on_interaction_detection_body_entered(body):
	objectInteracting = body
	

func _on_interaction_detection_body_exited(_body):
	objectInteracting = null
	
