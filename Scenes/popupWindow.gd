extends Window

@onready var med_slide = $Control/Panel/Medicine/MedicinesSlide
@onready var mat_slide = $Control/Panel/Materials/MaterialsSlide
@onready var know_slide = $Control/Panel/Knowledge/KnowledgeSlide
@onready var secu_slide = $Control/Panel/Security/SecuritySlide
@onready var food_slide = $Control/Panel/Food/FoodSlide
@onready var tools_slide = $Control/Panel/Tools/ToolsSlide

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func setCurrentValues(resources:Dictionary):
	if resources.has("medicine"):
		med_slide.value = resources["medicine"]
	else:
		med_slide.value = 0
	if resources.has("tools"):
		tools_slide.value = resources["tools"]
	else:
		tools_slide.value = 0
	if resources.has("knowledge"):
		know_slide.value = resources["knowledge"]
	else:
		know_slide.value = 0
	if resources.has("security"):
		secu_slide.value = resources["security"]
	else:
		secu_slide.value = 0
	if resources.has("materials"):
		mat_slide.value = resources["materials"]
	else:
		mat_slide.value = 0
	if resources.has("food"):
		food_slide.value = resources["food"]
	else:
		food_slide.value = 0
	
	
func setMaxValues(resources:Dictionary):
	if resources.has("medicine"):
		med_slide.max_value = resources["medicine"]
	else:
		med_slide.max_value = 0
	if resources.has("tools"):
		tools_slide.max_value = resources["tools"]
	else:
		tools_slide.max_value = 0
	if resources.has("food"):
		food_slide.max_value = resources["food"]
	else:
		food_slide.max_value = 0
	if resources.has("materials"):
		mat_slide.max_value = resources["materials"]
	else:
		mat_slide.max_value = 0
	if resources.has("security"):
		sec_slide.max_value = resources["security"]
	else:
		sec_slide.max_value = 0
	if resources.has("knowledge"):
		know_slide.max_value = resources["knowledge"]
	else:
		know_slide.max_value = 0


func getResourceValues():
	var resources = {};
	resources["medicine"] = med_slide.value;
	resources["food"] = food_slide.value
	
	print(resources);
	return resources;
