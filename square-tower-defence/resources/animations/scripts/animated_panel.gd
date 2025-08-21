@tool
extends Panel
class_name AnimatedPanel

@export var starting_values : Dictionary[String,Variant] = {
	"position" : Vector2(0.5,0.5),
	"rotation_angle" : 0.0,
	"edges" : 3,
	"shape_feather" : 0.0,
	"progress" : 1.0,
}:
	set(new):
		starting_values = new
		reset()

var color : Color:
	set(new):
		color = new
		stylebox.bg_color = color
var animation_resources : Array[PanelAnimation]
var starting_material : ShaderMaterial = preload("uid://b0cobtuo68gj7").duplicate():
	set(new):
		starting_material = new
		material = starting_material

var on_alt = false
var on_mirror = false

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

func level_up():
	starting_values["edges"] += 1
	reset()

var stylebox = StyleBoxFlat.new()
var timer : Timer

func setup_from_container(container : PanelAnimationContainer):
	color = container.color
	animation_resources = container.animations.duplicate(true)
	starting_material = container.starting_material.duplicate(true)
	size = container.dimentions
	pivot_offset = size / 2
	starting_values = container.starting_values

func adjust_n_of_sides(new_num):
	starting_values["edges"] = new_num

func _ready() -> void:
	add_theme_stylebox_override("panel",stylebox)
	stylebox.bg_color = color
	material = starting_material
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(play_animation.bind(""))
	timer.one_shot = true
	for value in starting_values:
		material.set_shader_parameter(value,starting_values[value])
	true_duplicate()
	starting_material = starting_material.duplicate()
	pivot_offset = size / 2

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
			
		if not animation.loop:
			timer.stop()
		
		var properties = animation.properties
		
		if on_mirror:
			on_mirror = false
		elif animation.mirror_animation:
			on_mirror = true
		elif on_alt:
			on_alt = false
			properties = animation.secondary_animation.properties
		elif animation.secondary_animation:
			on_alt = true
		
		
		
		for property in properties:
			var tweener = create_tween()
			current_tweeners.append(tweener)
			if not on_mirror or not property.invert_on_flip:
				if property.number_animated:
					tweener.tween_method(func(value): material.set_shader_parameter(property.property,value),property.initial_value,property.final_value,property.end)
				else:
					tweener.tween_method(func(value): stylebox.set("bg_color",value),property.initial_color,property.final_color,property.end)
			else:
				if property.number_animated:
					tweener.tween_method(func(value): material.set_shader_parameter(property.property,value),property.final_value,property.initial_value,property.end)
				else:
					tweener.tween_method(func(value): stylebox.set("bg_color",value),property.final_color,property.initial_color,property.end)
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
	current_animation = animation_resources[index].animation_name
	play_animation(animation_resources[index].animation_name)

func stop(reset_stuff = true):
	for tweener in current_tweeners:
		tweener.stop()
	timer.stop()
	if reset_stuff:
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

func true_duplicate():
	var new_dict : Dictionary[String,Variant] = {}
	for key in starting_values:
		new_dict[key] = starting_values[key]
	starting_values = new_dict
	var dupe: Array[PanelAnimation] = []
	for animation in animation_resources:
		var anim := PanelAnimation.new()
		anim.animation_name = animation.animation_name
		anim.duration = animation.duration
		anim.loop = animation.loop
		
		for property in animation.properties:
			anim.properties.append(property.duplicate(true))
		anim.played = animation.played
		anim.on_secondary = animation.on_secondary
		if animation.secondary_animation:
			anim.secondary_animation = animation.secondary_animation.duplicate(true)
		dupe.append(anim)
	animation_resources = dupe
