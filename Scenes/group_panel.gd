extends Control


@export var group_name:String;
# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel/Name.text = group_name;
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
