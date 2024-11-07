extends Node

var materials = 0;
var medicines = 0;
var food = 0;
var tools = 0;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _to_string() -> String:
	var out = "";
	out += "materials: " + str(materials);
	out += "\nmedicines: " + str(medicines);
	out += "\nfood: " + str(food);
	out += "\ntools: " + str(tools);
	return out;
