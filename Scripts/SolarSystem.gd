extends Spatial

# Declare member variables here. Examples:
var fixed_time_step = 0.02;
var time_since_last = 0.0;
var celestial_bodies = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	for node in get_tree().get_nodes_in_group("celestial_bodies"):
		celestial_bodies.append(node);	

		NBodySystem.add_celestial_body(
			node.get_id(),
			node.get_reference_point(),
			node.get_mass(),
			node.get_radius(),
			node.get_initial_velocity(),
			node.get_global_transform().origin
		)
		
		print(node.get_id())
		print(node.get_reference_point())
		print(node.get_mass())
		print(node.get_radius())
		print(node.get_initial_velocity())
		print(node.get_global_transform().origin)
		
	print(celestial_bodies)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_since_last += delta;
	if(time_since_last < fixed_time_step):
		pass
		
	NBodySystem.run_simulation_step(1)
	
	for body in celestial_bodies:
		body.transform.origin = NBodySystem.get_body_position(int(body.get_id()));
