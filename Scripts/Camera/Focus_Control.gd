extends Control

var _earth_button;
var _moon_button;
var _camera;

func _ready():
	_camera = get_node("../CameraContainer/Camera");
	
	_earth_button = get_node("./EarthButton");
	var earth_node = get_node("../Earth");
	_earth_button.connect("pressed", self, "_button_pressed", [earth_node]);
	
	_moon_button = get_node("./MoonButton");
	var moon_node = get_node("../Moon");
	_moon_button.connect("pressed", self, "_button_pressed", [moon_node]);

func _button_pressed(node):
	print(str(node))
	_camera.update_pivot_node(node);
