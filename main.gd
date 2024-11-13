extends Node2D

@onready var stockpile = $Stockpile;
@onready var medicine_input = $Control/ResourcePools/ItemList/MedicalInput
@onready var food_input = $Control/ResourcePools/ItemList/FoodInput
@onready var materials_input = $Control/ResourcePools/ItemList/MaterialsInput
@onready var tools_input = $Control/ResourcePools/ItemList/ToolsInput
@onready var knowledge_input = $Control/ResourcePools/ItemList/KnowledgeInput
@onready var security_input = $Control/ResourcePools/ItemList/SecurityInput


var groups: Array[Group] = [];
var allocated_resoureces = {}:
	get:
		allocated_resoureces["food"] = 0.0;
		allocated_resoureces["medicine"] = 0.0;
		allocated_resoureces["material"] = 0.0;
		allocated_resoureces["tools"] = 0.0;
		allocated_resoureces["knowledge"] = 0.0;
		allocated_resoureces["security"] = 0.0;
		for group in groups:
			for key in allocated_resoureces.keys():
				if key in group.expected_input.keys(): 
					allocated_resoureces[key] += group.expected_input[key];
		
		return allocated_resoureces;

var resource_change_history = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for type in Group.GroupTypes:
		match Group.GroupTypes[type]:
			Group.GroupTypes.MEDICAL:
				print("type: medical");
				groups.append(Group.MedicalGroup.new(type));
			Group.GroupTypes.GATHERER:
				print("type: gatherer");
				groups.append(Group.GathererGroup.new(type));
			Group.GroupTypes.FARMER:
				print("type: farmer");
				groups.append(Group.FarmerGroup.new(type));
			Group.GroupTypes.FACTORY:
				print("type: factory");
				groups.append(Group.FactoryGroup.new(type));
			Group.GroupTypes.RESEARCH:
				print("type: research");
				groups.append(Group.ResearchGroup.new(type));
			Group.GroupTypes.MILITARY:
				print("type: military");
				groups.append(Group.MilitaryGroup.new(type));
			_:
				print("??")
	
	#groups[0].setInput({"material": 100, "food": 100, "knowledge": 100}); #manual for now
	for group in groups:
		group.setInput(group.expected_input);
	
	# Connect LineEdit nodes' text_entered signals to handle user input
	$Control/ResourcePools/ItemList/MedicineInput.connect("_on_input_entered", ["Medical"](self, "text_entered")
	$Control/ResourcePools/ItemList/FoodInput.connect("text_entered", self, "_on_input_entered", ["Food"])
	$Control/ResourcePools/ItemList/MaterialsInput.connect("text_entered", self, "_on_input_entered", ["Materials"])
	$Control/ResourcePools/ItemList/ToolsInput.connect("text_entered", self, "_on_input_entered", ["Tools"])
	$Control/ResourcePools/ItemList/KnowledgeInput.connect("text_entered", self, "_on_input_entered", ["Knowledge"])
	$Control/ResourcePools/ItemList/SecurityInput.connect("text_entered", self, "_on_input_entered", ["Security"])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$ResourceLabel.text = "Total Resources: \n" + stockpile.to_string();
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next_turn"):
		if checkResourceAvailability():
			processTurn();
			print("next turn");

func processTurn():
	var past_stockpile = stockpile.resources.duplicate();
	updateAllocatedResources();
	for group in groups:
		group.processTurn(stockpile.resources);
	
	var net_change = stockpile.resources.duplicate();
	var net_change_text = "Net Change: \n";
	for resource in net_change:
		net_change[resource] -= past_stockpile[resource];
		net_change_text += resource + ": ";
		net_change_text += str(net_change[resource]) + "\n";
	
	resource_change_history.append(net_change);
	$NetChangeLabel.text = net_change_text;


# should be called everytime user enters an input to resources.
func updateAllocatedResources():
	var out:String = "Resources Spent:\n";
	var alloc = allocated_resoureces.duplicate();
	for resource in alloc.keys():
		out += resource + ": ";
		out += str(alloc[resource]);
		out += "\n";
	$AllocationLabel.text = out;

func checkResourceAvailability():
	return true;
	
	for resource in allocated_resoureces.keys():
		if stockpile.resources[resource] < allocated_resoureces[resource]:
			print("INSUFFICIENT RESOURCES");
			return false;
	return true;
