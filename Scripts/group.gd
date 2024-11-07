extends Node
enum GroupTypes {
	MEDICAL,
	GATHERER,
	FACTORY,
	RESEARCH,
	MILITARY
}
var groups = [];

func _ready():
	for type in GroupTypes:
		match GroupTypes[type]:
			GroupTypes.MEDICAL:
				print("type: medical");
				groups.append(MedicalGroup.new(type));
			GroupTypes.GATHERER:
				print("type: gatherer");
				groups.append(Group.new(type));
			GroupTypes.FACTORY:
				print("type: factory");
				groups.append(Group.new(type));
			GroupTypes.RESEARCH:
				print("type: research");
				groups.append(Group.new(type));
			GroupTypes.MILITARY:
				print("type: military");
				groups.append(Group.new(type));
			_:
				print("??")
		
		
		

func processTurn():
	for group in groups:
		group.processTurn();


class Group:
	var stability: float; # stability = 1 - (infected/(health+infected)) and maybe some modifier for stability?
	var resource_satisfaction:
		get: 
			var count = 0;
			var total: float = 0;
			for resource in resource_types:
				if expected_input[resource] != 0:
					total += clamp(recieved_input[resource]/expected_input[resource], 0, 1.1);
					count += 1;
			return total/count;
			
	var production_ratio; # in terms of product/ unit(s) of input. to be multiplied by population
	var population
	var recieved_input = {};
	var expected_input = {}; # total expected input
	var production_costs = {}; # raw amounts of resources needed
	
	var resource_types = ["medicine", "food", "material", "tools", ]
	var my_type: GroupTypes;


	func _init(type):
		my_type = GroupTypes[type];
		stability = 1;
		for resource in resource_types:
			recieved_input[resource] = 0;
			expected_input[resource] = 0;
		calculate_expected_resources();

	func calculate_expected_resources():
		for key in production_costs.keys():
			expected_input[key] = population * production_costs[key];
			
		

# bug left here TODO TODO TODO
	func process_output():
		var output = population * production_ratio * stability * resource_satisfaction;
		return output;
		

	func processTurn():
		# recieve input
		recieved_input["materials"] = 50;
		recieved_input["food"] = 50;
		recieved_input["knowledge"] = 50;
		
		
		# update stability based on resource satisfaction
		stability = (stability + resource_satisfaction)/2
		print(str(process_output()));
		# feed process_output() into stockpile
		calculate_expected_resources();
		pass
		


		
class MedicalGroup extends Group:
	func _init(type):
		population = 100;
		production_costs["knowledge"] = 1;
		production_costs["food"] = 1;
		production_costs["material"] = 1;
		production_ratio = 1;
		super._init(type);
