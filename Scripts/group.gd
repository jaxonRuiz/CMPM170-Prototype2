class_name Group extends Node
enum GroupTypes {
	MEDICAL,
	GATHERER,
	FARMER,
	FACTORY,
	RESEARCH,
	MILITARY
}

var stability: float; # stability = 1 - (infected/(health+infected)) and maybe some modifier for stability?
var resource_satisfaction:
	get: 
		var count = 0.0;
		var total: float = 0.0;
		for resource in expected_input.keys():
			if expected_input[resource] != 0:
				total += clamp(float(recieved_input[resource]) / float(expected_input[resource]), 0, 1.1);
				count += 1;
		return total/count;
		
var production_ratio; # in terms of product/ unit(s) of input. to be multiplied by population
var population;
var recieved_input = {};
var expected_input = {}; # total expected input
var production_costs = {}; # raw amounts of resources needed
var additional_upkeep = {}; # extra resources needed circumstantially
var output_type: String;

var resource_types = ["medicine", "food", "material", "tools", "knowledge", "security"]
var my_type: GroupTypes;


func _init(type):
	#print("initializing Group of type: " + str(type));
	my_type = GroupTypes[type];
	stability = 1.0;
	for resource in resource_types:
		recieved_input[resource] = 0;
	calculate_expected_resources();

func calculate_expected_resources():
	for key in production_costs.keys():
		expected_input[key] = population * production_costs[key];
		
	

func process_output():
	var output = population * production_ratio * stability * resource_satisfaction;
	return output;
	

# overflow resources just aren't used
func setInput(resources:Dictionary):
	for resource in resources.keys():
		recieved_input[resource] = resources[resource];

func processTurn(stockpile:Dictionary):	
	
	# update stability based on resource satisfaction
	stability = (stability + resource_satisfaction + 0.1)/2
	printraw(my_type);
	print(stability);
	for resource in expected_input.keys():
		if recieved_input[resource] <= expected_input[resource] * 1.1:
			stockpile[resource] -= recieved_input[resource];
		else:
			stockpile[resource] -= expected_input[resource] * 1.1;
	
	print("produced: %d %s" % [process_output(), output_type]);
	stockpile[output_type] += process_output();
	# feed process_output() into stockpile
	calculate_expected_resources();
	pass
	

class MedicalGroup extends Group:
	func _init(type):
		population = 80;
		production_costs["knowledge"] = 0.5;
		production_costs["food"] = 0.2;
		production_costs["material"] = 0.4;
		production_ratio = 0.2;
		output_type = "medicine";
		super._init(type);

class GathererGroup extends Group:
	func _init(type):
		population = 300;
		production_costs["food"] = 0.4;
		production_costs["tools"] = 0.2;
		production_ratio = 2;
		output_type = "material";
		super._init(type);

class FarmerGroup extends Group:
	func _init(type):
		population = 300;
		production_costs["security"] = 0.2;
		production_costs["tools"] = 0.02;
		production_ratio = 10;
		output_type = "food";
		super._init(type);

class FactoryGroup extends Group:
	func _init(type):
		population = 150;
		production_costs["food"] = 3.5;
		production_costs["material"] = 3.5;
		production_ratio = 3.5;
		output_type = "tools";
		super._init(type);

class ResearchGroup extends Group:
	func _init(type):
		population = 50;
		production_costs["food"] = 0.1;
		production_costs["tools"] = 0.1;
		production_ratio = 10;
		output_type = "knowledge";
		super._init(type);

class MilitaryGroup extends Group:
	func _init(type):
		population = 100;
		production_costs["medicine"] = 2.5;
		production_costs["food"] = 1.25;
		production_costs["tools"] = 2.5;
		production_ratio = 2.5;
		output_type = "security";
		super._init(type);
