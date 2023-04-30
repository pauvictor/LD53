extends Node2D

@onready var bdLabel = $CanvasLayer/BabiesDeliveredLabel
@onready var sLabel = $CanvasLayer/ScoreLabel

func _ready():
	sLabel.text = "High Score: " + str(Global.high_score)
	bdLabel.text = "Max Babies Delivered: " + str(Global.babies_delivered)

func _on_button_pressed():
	get_tree().change_scene_to_packed(load('res://Scenes/MainMenu.tscn'))
