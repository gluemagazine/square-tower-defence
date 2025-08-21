extends Node2D
class_name CameraMan

@export var camera : PhantomCamera2D
@export var max_zoom : float = 4
@export var min_zoom : float = 1.7
var limits : Dictionary
var zoom = 2:
	set(new):
		zoom = new
		camera.zoom = Vector2(zoom,zoom)

#phantom camera properties
#_limit_sides.x = limit_left
#_limit_sides.y = limit_top
#_limit_sides.z = limit_right
#_limit_sides.w = limit_bottom

func _physics_process(delta: float) -> void:
	var dir = Input.get_vector("left","right","up","down")
	
	camera.global_position += dir * delta * 100
	bind_to_area()
	

func bind_to_area():
	var rect = get_viewport_rect().size * 1/2 * 1/zoom
	var limit_left_corner = Vector2(camera._limit_sides.x,camera._limit_sides.y) + rect
	var limit_right_corner= Vector2(camera._limit_sides.z,camera._limit_sides.w) - rect
	
	camera.global_position.x = clamp(camera.global_position.x,limit_left_corner.x,limit_right_corner.x)
	camera.global_position.y = clamp(camera.global_position.y,limit_left_corner.y,limit_right_corner.y)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				MOUSE_BUTTON_WHEEL_UP:
					zoom += 0.1
				MOUSE_BUTTON_WHEEL_DOWN:
					zoom -= 0.1
		zoom = clamp(zoom,min_zoom,max_zoom)
