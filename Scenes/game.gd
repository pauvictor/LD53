extends Node2D

@onready var actionLabel = $CanvasLayer/ActionLabel
@onready var scoreLabel = $CanvasLayer/ScoreLabel
@onready var babiesDeliveredLabel = $CanvasLayer/BabiesDeliveredLabel

var totalScore = 0
var totalBabies = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	inscrease_score_label(0)
	increase_babies_label(0)
	

func set_action_label(text):
	actionLabel.text = text

func inscrease_score_label(score):
	totalScore+=score
	scoreLabel.text = "Score: " + str(totalScore)

func increase_babies_label(babies):
	totalBabies+=babies
	babiesDeliveredLabel.text = "Babies delivered: " + str(totalBabies)

func report_scores():
	if(totalScore > Global.high_score):
		Global.high_score = totalScore
	if(totalBabies > Global.babies_delivered):
		Global.babies_delivered = totalBabies
