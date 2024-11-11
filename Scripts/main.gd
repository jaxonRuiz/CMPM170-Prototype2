extends Node2D

@onready var stockpile = $Stockpile;
var groups: Array[Group] = [];
var allocated_resoureces = {
	"food": 0.0,
	"medicine": 0.0,
	"material": 0.0,
	"tools": 0.0,
	"knowledge": 0.0,
	"security": 0.0
}:
	get:
		allocated_resoureces["food"] = 0.0;
		allocated_resoureces["medicine"] = 0.0;
		allocated_resoureces["material"] = 0.0;
		allocated_resoureces["tools"] = 0.0;
		allocated_resoureces["knowledge"] = 0.0;
		for group in groups:
			for key in allocated_resoureces.keys():
				allocated_resoureces[key] += group.expected_input[key];
		
		return allocated_resoureces;
			
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#for type in Group.GroupTypes:
		#groups.append(Group.new(type))
	for type in Group.GroupTypes:
		match Group.GroupTypes[type]:
			Group.GroupTypes.MEDICAL:
				print("type: medical");
				groups.append(Group.MedicalGroup.new(type));
				break; # only testing medical for now
			Group.GroupTypes.GATHERER:
				print("type: gatherer");
				groups.append(Group.new(type));
			Group.GroupTypes.FACTORY:
				print("type: factory");
				groups.append(Group.new(type));
			Group.GroupTypes.RESEARCH:
				print("type: research");
				groups.append(Group.new(type));
			Group.GroupTypes.MILITARY:
				print("type: military");
				groups.append(Group.new(type));
			_:
				print("??")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = stockpile.to_string();
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next_turn"):
		groups[0].setInput({"material": 100, "food": 100, "knowledge": 100}); #manual for now
		processTurn();
		print("next turn");

func processTurn():
	for group in groups:
		group.processTurn(stockpile.resources);
