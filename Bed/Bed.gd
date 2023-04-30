extends StaticBody2D

#Constants
enum BedOcupation {Empty, Brunete, Blond, RedHead}
var animations = {BedOcupation.Brunete: [0,3,6,9,12], BedOcupation.Blond: [1,4,7,10,13], BedOcupation.RedHead: [2,5,8,11,14]}
const CALM = 0
const PAIN = 1
const STRESSED = 2
const FYOU = 3
const BABY = 4

@onready var mumSprite = $MumSprite
@onready var initialOcupationTimer = $InitialOcupationTimer
@onready var painLabel = $PainLabel
@onready var babyProgressBar = $ProgressBarBaby
@onready var stateMachineTimer = $StateMachineTimer
@onready var babyCrySound = $BabyCry
@onready var deliverySound = $Delivery
@onready var gameNode = get_tree().get_nodes_in_group("gameNode").front()
#variables that updates between runs
var difficulty = 0.1
var babyProgressCalibration = 5

#Variables for one delivery
var bedStatus : BedOcupation = BedOcupation.Empty
var stress = 0.0
var babyProgress = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	initialOcupationTimer.start(randf_range(2,10))
	difficulty = randf_range(0.1, 0.2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(bedStatus != BedOcupation.Empty):		
		_update_stress(delta)
		_update_baby(delta)
	

func _update_stress(delta):
	if(babyProgress != 100):	
		stress = clampf(stress + (delta * difficulty), 0, 6);
		_update_stress_label()
		if(stress >= 5.8):
			if(gameNode.has_method("report_scores")):
				gameNode.report_scores()
			get_tree().change_scene_to_packed(load('res://Scenes/gameOver.tscn'))
		mumSprite.frame = animations[bedStatus][int(clampf(stress,0,3.2))]
	else:
		stress = 0
		_update_stress_label()
	

func _update_stress_label():
		if(stress >= 3):		
			painLabel.text = "!!!"
		elif(stress >= 2):
			painLabel.text = "!!"
		elif(stress >= 1):
			painLabel.text = "!"
		else:
			painLabel.text = ""

func _update_baby(delta):
	babyProgress = clampf(babyProgress + (delta * babyProgressCalibration),0,100);
	babyProgressBar.value = babyProgress
	if(babyProgress > 98 and babyProgress < 100):
		if(not deliverySound.playing):
			deliverySound.play()
	if(babyProgress == 100):
		mumSprite.frame = animations[bedStatus][BABY]
	

func execute_action(hasBaby):
	if(babyProgress == 100 and not hasBaby):
		stress = 0
		babyProgress = 0
		babyProgressBar.value = 0
		painLabel.text = ""
		bedStatus = BedOcupation.Empty
		mumSprite.visible = false
		initialOcupationTimer.start(randf_range(0,clampf(10-difficulty, 0, 10)))
		gameNode.inscrease_score_label(100)
		difficulty+=randf_range(0.05, 0.1)
		babyCrySound.stop()
		return "baby"
	elif (stress > 1):
		stress-=1
		gameNode.inscrease_score_label(100)
	
	return null

func get_text(hasBaby):
	if(hasBaby):
		return "Place the baby you are carrying in the crib first"
	if(babyProgress == 100):
		return "Press e or space to get the baby"
	elif(stress > 1):
		return "Press e or space to reduce the pain of the mum"
	else:
		return ""
	

func _on_initial_ocupation_timeout():
	bedStatus = BedOcupation.values()[randi_range(1,3)]
	mumSprite.visible = true
	mumSprite.frame = animations[bedStatus][0]

func _on_delivery_finished():
	babyCrySound.play()
	deliverySound.stop()
