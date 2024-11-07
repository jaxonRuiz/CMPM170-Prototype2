extends Node2D

@onready var stockpile = $Stockpile;
@onready var groups = $Groups;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = stockpile.to_string();
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next_turn"):
		processTurn();
		print("next turn");

func processTurn():
	pass
	
