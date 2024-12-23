extends Node2D

@onready var window = $Window

@onready var stockpile = Stockpile.new();
var groups: Array[Group] = [];
var currentGroupI = 0;
var total_population:
	get:
		var count = 0;
		for group in groups:
			count += group.population;
		return count;
var total_infected:
	get:
		var count = 0;
		for group in groups:
			count += group.infected;
		return count;
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
				groups.append(Group.MedicalGroup.new(type, $GroupBox1));
			Group.GroupTypes.GATHERER:
				print("type: gatherer");
				groups.append(Group.GathererGroup.new(type, $GroupBox2));
			Group.GroupTypes.FARMER:
				print("type: farmer");
				groups.append(Group.FarmerGroup.new(type, $GroupBox3));
			Group.GroupTypes.FACTORY:
				print("type: factory");
				groups.append(Group.FactoryGroup.new(type, $GroupBox4));
			Group.GroupTypes.RESEARCH:
				print("type: research");
				groups.append(Group.ResearchGroup.new(type, $GroupBox5));
			Group.GroupTypes.MILITARY:
				print("type: military");
				groups.append(Group.MilitaryGroup.new(type, $GroupBox6));
			_:
				print("??")
	
	for group in groups:
		group.setInput(group.expected_input);
	processTurn();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$ResourceLabel.text = "Total Resources: \n" + stockpile.to_string();
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next_turn"):
		if checkResourceAvailability():
			processTurn();

func processTurn():
	print("next turn");
	
	var past_stockpile = stockpile.resources.duplicate();
	updateAllocatedResources();
	for group in groups:
		group.processTurn(stockpile.resources);
	
	var net_change = stockpile.resources.duplicate();
	var net_change_text = "Net Change: \n";
	for resource in net_change:
		net_change[resource] -= past_stockpile[resource];
		net_change_text += resource + ": ";
		net_change_text += str(floor(net_change[resource])) + "\n";
	$ProgressBar.value = round(total_infected/(total_population+total_infected) * 100)
	resource_change_history.append(net_change);
	$NetChangeLabel.text = net_change_text;


# should be called everytime user enters an input to resources.
func updateAllocatedResources():
	print("update")
	var out:String = "Resources To Be Spent:\n";
	var alloc = allocated_resoureces.duplicate();
	for resource in alloc.keys():
		out += resource + ": ";
		out += str(floor(alloc[resource]));
		out += "\n";
	$AllocationLabel.text = out;

func checkResourceAvailability():
	return true;
	
	for resource in allocated_resoureces.keys():
		if stockpile.resources[resource] < allocated_resoureces[resource]:
			print("INSUFFICIENT RESOURCES");
			return false;
	return true;

# next turn button
func _on_button_pressed() -> void:
	processTurn();


func processWindow():
	window.setCurrentValues(groups[currentGroupI].recieved_input)
	window.setMaxValues(groups[currentGroupI].expected_input);
	window.show();
	

func _on_group_box_1_open_popup() -> void:
	print("main: button pressed");
	currentGroupI = 0;
	processWindow();
	pass # Replace with function body.

func _on_group_box_2_open_popup() -> void:
	currentGroupI = 1;
	processWindow();
	pass # Replace with function body.

func _on_group_box_3_open_popup() -> void:
	currentGroupI = 2;
	processWindow();
	pass

func _on_group_box_4_open_popup() -> void:
	currentGroupI = 3;
	processWindow();
	pass

func _on_group_box_5_open_popup() -> void:
	currentGroupI = 4;
	processWindow();
	pass

func _on_group_box_6_open_popup() -> void:
	currentGroupI = 5;
	processWindow();
	pass


func _on_window_close_requested() -> void:
	groups[currentGroupI].setInput($Window.getResourceValues());
	updateAllocatedResources();
	$Window.hide();
