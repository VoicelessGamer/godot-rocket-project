extends Camera

export(NodePath) var pivot_node_path setget set_pivot_node_path;

export (float, 0.0, 1.0) var sensitivity = 0.5;
export (float, 0.0, 0.999, 0.001) var smoothness = 0.5 setget set_smoothness;
export (int, 0, 90) var pitch_limit = 90;

var _yaw = 0.0;
var _pitch = 0.0;
var _distance = 0.0;

var _current_event = ""; 
var _movement_triggered = false;
var _initial_move_point = Vector2();
var _current_move_point = Vector2();
var _initial_yaw = 0.0;
var _initial_pitch = 0.0;

var _container_node = null;
var _pivot_node = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	_container_node = get_node("../../CameraContainer");
	_pivot_node = get_node(pivot_node_path);
	#add_camera_to_pivot()
	_container_node.transform.origin = Vector3(0, 0, 0);
	update_view(0);
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_view(delta);
	#print("rot: " + str(_container_node.get_rotation()));
	pass

func set_smoothness(value):
	smoothness = clamp(value, 0.001, 0.999);

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
	#_yaw = _yaw * smoothness + (1.0 - smoothness)
	#_pitch = _pitch * smoothness + (1.0 - smoothness);

	if _pivot_node:
		# Put the container in the same translation as the body
		var target = _pivot_node.get_translation();
		_container_node.set_translation(target);
		
		#var dist = get_translation().distance_to(target);
		
		#var yaw_to_rotate = (_yaw - rad2deg(get_rotation().y)) * smoothness;
		#var pitch_to_rotate = (_pitch - rad2deg(get_rotation().x)) * smoothness;
		
		_container_node.set_rotation(Vector3(0, deg2rad(_yaw), deg2rad(_pitch)));
		
		#if yaw_to_rotate > 0.01:
			#rotate_y(deg2rad(-yaw_to_rotate));
			#rotate_object_local(Vector3(0, 1, 0), deg2rad(-yaw_to_rotate));
		#if pitch_to_rotate > 0.01:
			#rotate_x(deg2rad(-pitch_to_rotate));
			#rotate_object_local(Vector3(1, 0, 0), deg2rad(-pitch_to_rotate));

		#rotate_y(deg2rad(-_yaw));
		#rotate_object_local(Vector3(1, 0, 0), deg2rad(-_pitch));
		
		#translate(Vector3(0.0, 0.0, dist));
		
func _input(event):
	if _current_event == "":
		
		if event.is_action_pressed("ui_right_click"):
			_current_event = "ui_right_click";
			_movement_triggered = true;
			_initial_move_point = event.position;
			print("rot2: " + str(_container_node.get_rotation()));
			_initial_yaw = rad2deg(_container_node.get_rotation().y);
			_initial_pitch = _container_node.get_rotation_degrees().z;
	elif _current_event != "":
		if event.is_action_released("ui_right_click"):
			_current_event = "";
			_movement_triggered = false;
			print("rot6: " + str(_container_node.get_rotation()));
			
			#_yaw = _container_node.get_rotation_degrees().y;
			#_pitch = _container_node.get_rotation_degrees().x;
			
	if _movement_triggered:
		var _new_move_point = event.position - _initial_move_point;
		
		if _current_move_point != _new_move_point:
			_current_move_point = _new_move_point;
			
			var offset = _current_move_point * sensitivity;
			
			
			_yaw = -(_initial_yaw + offset.x);
			_pitch = _initial_pitch + offset.y;
			
			print("rot5: " + str(_container_node.get_rotation()));
			
			_pitch = clamp(_pitch, -pitch_limit, pitch_limit);
