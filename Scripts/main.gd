extends Node2D

@onready var stockpile = $Stockpile;
var groups: Array[Group] = [];
var allocated_resoureces = {}:
	get:
		allocated_resoureces["food"] = 0.0;
		allocated_resoureces["medicine"] = 0.0;
		allocated_resoureces["material"] = 0.0;
		allocated_resoureces["tools"] = 0.0;
		allocated_resoureces["knowledge"] = 0.0;
		for group in groups:
			for key in allocated_resoureces.keys():
				if key in group.expected_input.keys(): 
					allocated_resoureces[key] += group.expected_input[key];
		
		return allocated_resoureces;
			
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$ResourceLabel.text = stockpile.to_string();
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next_turn"):
		if checkResourceAvailability():
			processTurn();
			print("next turn");

func processTurn():
	for group in groups:
		group.processTurn(stockpile.resources);

func checkResourceAvailability():
	return true;
	for resource in allocated_resoureces.keys():
		if stockpile.resources[resource] < allocated_resoureces[resource]:
			print("INSUFFICIENT RESOURCES");
			return false;
	return true;
