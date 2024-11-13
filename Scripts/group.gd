class_name Group extends Node
enum GroupTypes {
	MEDICAL,
	GATHERER,
	FARMER,
	FACTORY,
	RESEARCH,
	MILITARY
}
const OVERFLOW_AMOUNT = 1.2; # amount production/stability can be overclocked by excess resources.

var stability: float; # stability = 1 - (infected/(health+infected)) and maybe some modifier for stability?
var group_box;
var resource_satisfaction:
	get: 
		var count = 0.0;
		var total: float = 0.0;
		for resource in expected_input.keys():
			if expected_input[resource] != 0:
				total += clamp(float(recieved_input[resource]) / float(expected_input[resource]), 0, OVERFLOW_AMOUNT);
				count += 1;
		return total/count;
		
var production_ratio; # in terms of product/ unit(s) of input. to be multiplied by population
var population: 
	set(pop):
		if pop > 0:
			population = pop;
		else:
			population = 0;
var recieved_input = {};
var expected_input = {}; # total expected input
var production_costs = {}; # raw amounts of resources needed
var additional_upkeep = {}; # extra resources needed circumstantially
var output_type: String;
var infected = 1;
var infected_percent:
	get:
		if population == 0: return 1;
		return infected/(infected+population);

var resource_types = ["medicine", "food", "material", "tools", "knowledge", "security"]
var my_type: GroupTypes;


func _init(type, ui):
	#print("initializing Group of type: " + str(type));
	group_box = ui;
	group_box.setNameLabel(type);
	my_type = GroupTypes[type];
	stability = 1.0;
	group_box.loadTextures(str(type).to_lower().left(3));
	for resource in resource_types:
		recieved_input[resource] = 0;
	calculate_expected_resources();

func calculate_expected_resources():
	for key in production_costs.keys():
		expected_input[key] = population * production_costs[key];
		
	

func process_output():
	if population == 0: return 0;
	var output = population * production_ratio * stability * resource_satisfaction# * randf_range(0.8, 1.2);
	return output;
	

# overflow resources just aren't used
func setInput(resources:Dictionary):
	for resource in resources.keys():
		recieved_input[resource] = resources[resource];

func processTurn(stockpile:Dictionary):	
	
	# update stability based on resource satisfaction
	stability = (stability + resource_satisfaction )/2
	group_box.setStabilityBar(int(stability*100))
	for resource in expected_input.keys():
		if recieved_input[resource] <= expected_input[resource] * OVERFLOW_AMOUNT:
			stockpile[resource] -= recieved_input[resource];
		else:
			stockpile[resource] -= expected_input[resource] * OVERFLOW_AMOUNT;
	
	stockpile[output_type] += process_output();

	population *= (recieved_input["food"]/expected_input["food"]) + 0.12;
	if infected > 0:
		var new_infected = round(infected * 0.5)
		infected += new_infected;
		population -= new_infected
	
	group_box.updateInfectionBar(round(infected_percent*100));
	group_box.updatePopulation(population);
	calculate_expected_resources();
	
	

class MedicalGroup extends Group:
	func _init(type, ui):
		population = 80;
		production_costs["knowledge"] = 0.5;
		production_costs["food"] = 0.2;
		production_costs["material"] = 0.4;
		production_ratio = 3.25;
		output_type = "medicine";
		
		super._init(type, ui);

class GathererGroup extends Group:
	func _init(type, ui):
		population = 300;
		production_costs["food"] = 0.4;
		production_costs["tools"] = 0.2;
		production_ratio = 2;
		output_type = "material";
		super._init(type, ui);

class FarmerGroup extends Group:
	func _init(type, ui):
		population = 300;
		production_costs["security"] = 0.2;
		production_costs["tools"] = 0.2;
		production_costs["food"] = 0.2;
		production_ratio = 3;
		output_type = "food";
		super._init(type, ui);

class FactoryGroup extends Group:
	func _init(type, ui):
		population = 150;
		production_costs["food"] = 3.5;
		production_costs["material"] = 3.5;
		production_ratio = 2.6;
		output_type = "tools";
		super._init(type, ui);

class ResearchGroup extends Group:
	func _init(type, ui):
		population = 50;
		production_costs["food"] = 0.2;
		production_costs["tools"] = 0.2;
		production_ratio = 1;
		output_type = "knowledge";
		super._init(type, ui);

class MilitaryGroup extends Group:
	func _init(type, ui):
		population = 100;
		production_costs["medicine"] = 2.5;
		production_costs["food"] = 1.25;
		production_costs["tools"] = 2.5;
		production_ratio = 0.75;
		output_type = "security";
		super._init(type, ui);
