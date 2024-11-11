class_name Group extends Node
enum GroupTypes {
	MEDICAL,
	GATHERER,
	FACTORY,
	RESEARCH,
	MILITARY
}

#func _ready():
	#for type in GroupTypes:
		#match GroupTypes[type]:
			#GroupTypes.MEDICAL:
				#print("type: medical");
				#groups.append(MedicalGroup.new(type));
			#GroupTypes.GATHERER:
				#print("type: gatherer");
				#groups.append(Group.new(type));
			#GroupTypes.FACTORY:
				#print("type: factory");
				#groups.append(Group.new(type));
			#GroupTypes.RESEARCH:
				#print("type: research");
				#groups.append(Group.new(type));
			#GroupTypes.MILITARY:
				#print("type: military");
				#groups.append(Group.new(type));
			#_:
				#print("??")
				#
#func processTurn():
	#for group in groups:
		#group.processTurn();


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
var population
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
	

func setInput(resources:Dictionary):
	for resource in resources.keys():
		recieved_input[resource] = resources[resource];

func processTurn(stockpile:Dictionary):	
	
	# update stability based on resource satisfaction
	stability = (stability + resource_satisfaction)/2
	for resource in recieved_input.keys():
		stockpile[resource] -= recieved_input[resource];
	
	print("produced: %d %s" % [process_output(), output_type]);
	stockpile[output_type] += process_output();
	# feed process_output() into stockpile
	calculate_expected_resources();
	pass
	

class MedicalGroup extends Group:
	func _init(type):
		population = 100;
		production_costs["knowledge"] = 0.2;
		production_costs["food"] = 0.2;
		production_costs["material"] = 0.2;
		production_ratio = 0.2;
		output_type = "medicine";
		super._init(type);
