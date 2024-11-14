extends Window



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func setCurrentValues(resources:Dictionary):
	$Control/Panel/Medicine/MedicinesSlide.value = resources["medicine"]
	pass
	
func setMaxValues(resources:Dictionary):
	$Control/Panel/Medicine/MedicinesSlide.max_value = resources["medicine"]
	pass;


func getResourceValues():
	var resources = {};
	resources["medicine"] = $Control/Panel/Medicine/MedicinesSlide.value;
	resources["food"] = $Control/Panel/Food/FoodSlide.value
	
	print(resources);
	return resources;
