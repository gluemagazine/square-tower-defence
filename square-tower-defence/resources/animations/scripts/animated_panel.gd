@tool
extends Panel
class_name AnimatedPanel

@export var starting_values : Dictionary[String,Variant] = {
	"position" : Vector2(0.5,0.5),
	"rotation_angle" : 0.0,
	"edges" : 3,
	"shape_feather" : 0,
	"progress" : 1,
}

var color : Color:
	set(new):
		color = new
		stylebox.bg_color = color
var animation_resources : Array[PanelAnimation]
var starting_material : ShaderMaterial = preload("uid://b0cobtuo68gj7").duplicate():
	set(new):
		starting_material = new
		material = starting_material

func _get_property_list() -> Array[Dictionary]:
	var properties : Array[Dictionary] = []
	
	properties.append({
		"name": "color",
		"type": TYPE_COLOR,
		"usage": PROPERTY_USAGE_DEFAULT,
	})
	properties.append({
		"name": "animation_resources",
		"type": TYPE_ARRAY,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint" : PROPERTY_HINT_TYPE_STRING,
		"hint_string" : str("%d/%d:" + "PanelAnimation") % \
		[TYPE_OBJECT,PROPERTY_HINT_RESOURCE_TYPE]
	})
	properties.append({
		"name" : "starting_material",
		"type" : TYPE_OBJECT,
		"usage" : PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_TYPE_STRING,
		"hind_string" : str("TYPE_OBJECT/PROPERTY_HINY_RESOURCE_TYPE:ShaderMaterial")
	})
	return properties

var stylebox = StyleBoxFlat.new()
var timer : Timer

func setup_from_container(container : PanelAnimationContainer):
	color = container.color
	animation_resources = container.animations
	starting_material = container.starting_material
	size = container.dimentions

func adjust_n_of_sides(new_num):
	material.set_shader_parameter("sides",new_num)

func _ready() -> void:
	add_theme_stylebox_override("panel",stylebox)
	stylebox.bg_color = color
	material = starting_material
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(play_animation.bind(""))
	timer.one_shot = true

var current_tweeners : Array[Tween] = []
var current_animation = "walk"

func play_animation(animation_name):
	if animation_name == "":
		if current_animation != "":
			animation_name = current_animation
	
	#stop(false)
	for animation in animation_resources:
		if not animation.animation_name == animation_name:
			continue
		if animation.loop:
			timer.wait_time = animation.duration
			timer.start()
		var properties = animation.properties
		
		if animation.on_secondary:
			animation.on_secondary = false
			properties = animation.secondary_animation.properties
		elif animation.secondary_animation:
			animation.on_secondary = true
		
		
		
		for property in properties:
			var tweener = create_tween()
			current_tweeners.append(tweener)
			if property.number_animated:
				tweener.tween_method(func(value): material.set_shader_parameter(property.property,value),property.initial_value,property.final_value,property.end)
			else:
				tweener.tween_method(func(value): stylebox.set("bg_color",value),property.initial_color,property.final_color,property.end)

func play_on_top(animation_name):
	for animation in animation_resources:
		if not animation.animation_name == animation_name:
			continue
		for property in animation.properties:
			var tweener = create_tween()
			if property.number_animated:
				tweener.tween_method(func(value): material.set_shader_parameter(property.property,value),property.initial_value,property.final_value,property.end)
			else:
				tweener.tween_method(func(value): stylebox.set("bg_color",value),property.initial_color,property.final_color,property.end)

func play_index(index : int):
	current_animation = animation_resources[0].animation_name
	play_animation(animation_resources[0].animation_name)

func stop(reset = true):
	for tweener in current_tweeners:
		tweener.stop()
	timer.stop()
	if reset:
		reset()

func reset():
	for value in starting_values:
		material.set_shader_parameter(value,starting_values[value])
	stylebox.bg_color = color
	current_animation = ""

func create_container():
	var container = PanelAnimationContainer.new()
	container.color = color
	container.animations = animation_resources.duplicate(true)
	container.starting_material = starting_material.duplicate()
	container.dimentions = size 
	return container

@export_tool_button("run animation") var call : Callable = self.play_index.bind(0)
@export_tool_button("stop animation") var new_call : Callable = self.stop.bind(true)
