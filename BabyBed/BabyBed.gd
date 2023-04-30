extends StaticBody2D

@onready var successParicles = $SuccessParticles
@onready var bedSprite = $BedSprite
@onready var successTimer = $SuccessTimer
@onready var particleTimer = $ParticleTimer
@onready var gameNode = get_tree().get_nodes_in_group("gameNode").front()

var bedFull : bool = false

func _baby_placed():
	if(not bedFull):
		bedSprite.frame = 1
		bedFull = true
		successTimer.start()	

func get_text(hasBaby):
	if(hasBaby):
		return "Press e or space to put the baby to the crib"
	else:
		return "Get a baby from the mum and place it to the crib"

func execute_action(hasBaby):
	if(hasBaby and not bedFull):
		_baby_placed()
		gameNode.inscrease_score_label(200)
		gameNode.increase_babies_label(1)
		return "baby_bed"
	else:
		return ""
	

func _on_success_timer_timeout():
	successParicles.restart()
	particleTimer.start()

func _on_particle_timer_timeout():
	bedSprite.frame = 0
	bedFull = false
