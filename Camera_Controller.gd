extends Camera

export(NodePath) var pivot_node_path setget set_pivot_node_path;

export (float, 0.0, 1.0) var sensitivity = 0.25;
export (float, 0.1, 50.0) var acceleration = 20;
export (int, 0, 90) var pitch_limit = 90;

# Camera rotation variables
var _r_mouse_pressed = false;
var _initial_mouse_position;
var _initial_container_rotation;
var _target_container_rotation;
var _pitch_limit;

# Camera distance variables
var _distance = 0.0;

var _container_node = null;
var _pivot_node = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	_container_node = get_node("../../CameraContainer");
	_pivot_node = get_node(pivot_node_path);
	_container_node.transform.origin = Vector3(0, 0, 0);
	_pitch_limit = deg2rad(pitch_limit);
	update_view(0);
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_view(delta);
	pass

func set_pivot_node_path(node_path):
	pivot_node_path = node_path;	
	
func add_camera_to_pivot():
	if _pivot_node:
		_container_node.get_parent().remove_child(_container_node);
		_pivot_node.add_child(_container_node);
		_container_node.transform.origin = Vector3(0, 0, 0);
	
func update_distance_to_pivot_node():
	var n = _pivot_node as MeshInstance;
	_distance = n.get_mesh().get_radius() * 5.5;
	
	set_translation(Vector3(_distance, 0, 0));
	
func update_view(delta):
	if _pivot_node:
		update_distance_to_pivot_node();
		update_rotation(delta);
	
func update_rotation(delta):
	if _pivot_node:
		# Put the container in the same translation as the body
		#var target = _pivot_node.get_translation();
		#_container_node.set_translation(target);	_container_node.set_rotation(Vector3(0, rot.y - delta * _yaw, rot.z + delta *_pitch));
		
		var rot = _container_node.get_rotation();
		if _target_container_rotation:			
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
		
		var new_pitch = _initial_container_rotation.z + deg2rad(delta.y * sensitivity);
		new_pitch = clamp(new_pitch, -_pitch_limit, _pitch_limit);
		
		_target_container_rotation = Vector3(
			_initial_container_rotation.x, 
			_initial_container_rotation.y - deg2rad(delta.x * sensitivity), 
			new_pitch
		);

