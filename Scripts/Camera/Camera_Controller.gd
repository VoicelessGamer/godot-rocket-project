extends Camera

# Variables exported to the editor
export(NodePath) var pivot_node_path setget set_pivot_node_path;

export (float, 0.0, 1.0) var rotation_sensitivity = 0.25;
export (float, 0.0, 1.0) var pitch_sensitivity = 0.25;
export (float, 0.1, 50.0) var acceleration = 20;
export (float, 0.1, 50.0) var zoom_acceleration = 20;
export (int, 0, 90) var pitch_limit = 90;
export (float, 1.5, 20.0) var initialise_distance_factor = 4.0;
export (float, 1.5, 10.0) var min_distance_factor = 2.0;
export (float, 1.5, 20.0) var max_distance_factor = 20.0;
export (float, 1.0, 20.0) var zoom_factor = 20.0;

# Camera rotation variables
var _r_mouse_pressed = false;
var _initial_mouse_position;
var _initial_container_rotation;
var _target_container_rotation;
var _pitch_limit;

# Camera distance variables
var _distance;
var _min_distance;
var _max_distance;

# Node references
var _container_node = null;
var _pivot_node = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	_container_node = get_node("../../CameraContainer");
	_container_node.transform.origin = Vector3(0, 0, 0);
	_pitch_limit = deg2rad(pitch_limit);
	update_pivot_node(get_node(pivot_node_path));
	update_view(0);
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_view(delta);
	pass

func set_pivot_node_path(node_path):
	pivot_node_path = node_path;
	pass
	
func update_pivot_node(node):
	_pivot_node = node;
	add_camera_to_pivot();
	
func add_camera_to_pivot():
	if _pivot_node:
		# Re-parent and update container position
		_container_node.get_parent().remove_child(_container_node);
		_pivot_node.add_child(_container_node);
		_container_node.transform.origin = Vector3(0, 0, 0);
		
		# Initialise the camera position
		initialise_camera_distance();
	pass

func initialise_camera_distance():
	var r = (_pivot_node as MeshInstance).get_mesh().get_radius();
	_min_distance = r * min_distance_factor;
	_max_distance = r * max_distance_factor;
	_distance = r * initialise_distance_factor;
	set_translation(Vector3(_distance, 0, 0));
	pass
	
func update_view(delta):
	if _pivot_node:
		update_distance(delta);
		update_rotation(delta);
	pass
	
func update_distance(delta):
	self.translation.x = lerp(self.translation.x, _distance, delta * zoom_acceleration);
	
func update_rotation(delta):
	if _pivot_node and _target_container_rotation:
		_container_node.rotation.y = lerp(_container_node.rotation.y, _target_container_rotation.y, delta * acceleration);
		_container_node.rotation.z = lerp(_container_node.rotation.z, _target_container_rotation.z, delta * acceleration);
	pass

func _unhandled_input(event):	
	if event is InputEventMouseButton and event.get_button_index() == BUTTON_RIGHT:
		_r_mouse_pressed = event.is_pressed();
		
		if _r_mouse_pressed:
			_initial_mouse_position = event.position;
			_initial_container_rotation = _container_node.get_rotation();
			
	elif event is InputEventMouseMotion and _r_mouse_pressed:		
		var delta = event.position - _initial_mouse_position;
		
		var new_pitch = _initial_container_rotation.z + deg2rad(delta.y * pitch_sensitivity);
		new_pitch = clamp(new_pitch, -_pitch_limit, _pitch_limit);
		
		_target_container_rotation = Vector3(
			_initial_container_rotation.x, 
			_initial_container_rotation.y - deg2rad(delta.x * rotation_sensitivity), 
			new_pitch
		);
	elif event.is_action_pressed("zoom_in"):
		_distance = clamp(_distance - zoom_factor, _min_distance, _max_distance);
	elif event.is_action_pressed("zoom_out"):
		_distance = clamp(_distance + zoom_factor, _min_distance, _max_distance);
	pass
