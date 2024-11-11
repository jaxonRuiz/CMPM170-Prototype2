extends Node

var resources = {
	"food": 100.0,
	"medicine": 100.0,
	"material": 100.0,
	"tools": 100.0,
	"knowledge": 100.0,
	"security": 100.0
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _to_string() -> String:
	var out = "";
	out += "materials: " + str(resources["material"]);
	out += "\nmedicines: " + str(resources["medicine"]);
	out += "\nfood: " + str(resources["food"]);
	out += "\ntools: " + str(resources["tools"]);
	out += "\ntools: " + str(resources["knowledge"]);
	out += "\ntools: " + str(resources["security"]);
	return out;
