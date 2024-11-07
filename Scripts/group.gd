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
		print(type);
		groups.append(Group.new(type));
		



class Group:
	var stability; # stability = 1 - (infected/(health+infected)) and maybe some modifier for stability?
	var production_ratio; # in terms of product/ unit(s) of input. to be multiplied by population
	var population
	var input = {};
	var my_type: GroupTypes;


	func _init(i):
		print("creating group " + i);
		my_type = GroupTypes[i];
		print(my_type);

	func get_expected_resources():
		var total_expected = input.duplicate();
		# food demand = 0.2 * population


	func process_output():
		var output = population * production_ratio * stability;
		
		pass

	func update_turn():
		pass

		
class medical extends Group:
	func _init():
		population = 100;
		input["knowledge"] = 1;
