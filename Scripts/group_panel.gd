extends Control

@onready var nameLabel = %Name;
@onready var stabilityBar = %ProgressBar;
@onready var infectionBar = %TextureProgressBar;
@onready var populationLabel = %PopulationLabel;

# Called when the node enters the scene tree for the first time.
func _ready():

	$TextureProgressBar.value = 50;
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setNameLabel(name:String):
	nameLabel.text = name;

func setStabilityBar(stability:int):
	stabilityBar.value = stability;

func updateInfectionBar(infection:int):
	infectionBar.value = infection;

func loadTextures(code:String):
	infectionBar.texture_over = load("res://Assets/" + code + "ove.png")
	infectionBar.texture_progress = load("res://Assets/" + code + "prog.png")
	infectionBar.texture_under = load("res://Assets/" + code + "und.png")

func updatePopulation(pop:int):
	populationLabel.text = "Pop: " + str(pop);
