@tool
extends Panel
class_name AnimatedPanel

@export var starting_values : Dictionary[String,Variant] = {
	"position" : Vector2(0.5,0.5),
	"rotation_angle" : 0.0,
	"rotation_degrees" : 0.0,
	"edges" : 3,
	"shape_feather" : 0.0,
	"progress" : 1.0,
}:
	set(new):
		starting_values = new
		update_starting_values()
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

@export_category("easy animation")
@export var use_ending_values : bool = false
@export var override_animations : bool = false
@export var loop : bool = false
@export var mirror : bool = false
@export var duration : bool = false
@export var ending_color : Color = Color.WHITE

@export var ending_values : Dictionary[String,Variant] = {
	"position" : Vector2(0.5,0.5),
	"rotation_angle" : 0.0,
	"rotation_degrees" : 0.0,
	"edges" : 3,
	"shape_feather" : 0.0,
	"progress" : 1.0,
}

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
var easy_timer : Timer

func setup_from_container(container : PanelAnimationContainer):
	color = container.color
	if not container.override_animations:
		animation_resources = container.animations.duplicate(true)
	starting_material = container.starting_material.duplicate(true)
	size = container.dimentions
	pivot_offset = size / 2
	starting_values = container.starting_values
	update_starting_values()

func update_starting_values():
	for animation in animation_resources:
		for property in animation.properties:
			if not property.from_default: continue
			if property.property == "color":
				property.initial_color = color
			else:
				property.initial_value = starting_values[property.property]
				property.initial_value += starting_values[property.property]

func adjust_n_of_sides(new_num):
	starting_values["edges"] = new_num

func _ready() -> void:
	if not Engine.is_editor_hint():
		QOL.connect_pause_signals(self)
	add_theme_stylebox_override("panel",stylebox)
	stylebox.bg_color = color
	material = starting_material
	
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(play_animation.bind(""))
	timer.one_shot = true
	
	easy_timer = Timer.new()
	add_child(timer)
	easy_timer.timeout.connect(easy_animate)
	easy_timer.one_shot = true
	
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
	clear_invalid_tweeners()
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

var flip : bool = true

func easy_animate():
	for key in starting_values:
		if starting_values[key] != ending_values[key]:
			var tweener = create_tween()
			tweener.tween_method(func(value): material.set_shader_parameter(key,value),starting_values[key],ending_values[key],duration)
			current_tweeners.append(tweener)
	if color != ending_color:
		var tweener = create_tween()
		tweener.tween_method(func(value): stylebox.set("bg_color",value),color,ending_color,duration)
		current_tweeners.append(tweener)
	if loop:
		easy_timer.start()
	flip = !flip

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
		if value == "rotation_degrees":
			continue
		material.set_shader_parameter(value,starting_values[value])
	if starting_values.has("rotation_degrees"):
		rotation_degrees = starting_values["rotation_degrees"]
	stylebox.bg_color = color
	current_animation = ""
	current_tweeners = []

func clear_invalid_tweeners():
	var new = current_tweeners.duplicate()
	for tweener in current_tweeners:
		if not tweener.is_valid():
			new.erase(tweener)
	current_tweeners = new

func lock():
	if current_tweeners != []:
		for tweener in current_tweeners:
			tweener.pause()
	timer.paused = true
func unlock():
	if current_tweeners != []:
		for tweener in current_tweeners:
			if  tweener.is_valid():
				tweener.play()
	timer.paused = false

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
