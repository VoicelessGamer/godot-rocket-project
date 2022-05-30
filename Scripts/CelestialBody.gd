tool
extends MeshInstance

# Declare member variables here. Examples:
export (int) var cb_id = 0 setget set_id;
export (bool) var cb_reference_point = false setget set_reference_point;
export (float) var cb_mass = 1.0 setget set_mass;
export (float) var cb_radius = 1.0 setget set_radius;
export (Vector3) var initial_velocity = Vector3(0,0,0) setget set_initial_velocity;

func get_id():
	return cb_id;
	
func set_id(val):
	cb_id = val;

func get_reference_point():
	return cb_reference_point;
	
func set_reference_point(val):
	cb_reference_point = val;
	
func get_mass():
	return cb_mass;
	
func set_mass(val):
	cb_mass = val;
		
func get_radius():
	return cb_radius;
	
func set_radius(val):
	cb_radius = val
	
	get_mesh().set_radius(val)
	get_mesh().set_height(val*2)
	
func get_initial_velocity():
	return initial_velocity;

func set_initial_velocity(val):
	initial_velocity = val;
