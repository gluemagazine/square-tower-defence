extends Panel
class_name AnimatedPanel

@export var color : Color
@export var animation_resources : Array[PanelAnimation]
@export var starting_material : ShaderMaterial

var stylebox = StyleBoxFlat.new()
var animation_player : AnimationPlayer
var timer : Timer

func _ready() -> void:
	add_theme_stylebox_override("panel",stylebox)
	stylebox.bg_color = color
	material = starting_material.duplicate()
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
		else:
			return
	stop(false)
	for animation in animation_resources:
		if not animation.animation_name == animation_name:
			continue
		if animation.loop:
			timer.wait_time = animation.duration
			timer.start()
		
		for property in animation.properties:
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


func stop(reset = true):
	for tweener in current_tweeners:
		tweener.stop()
	if reset:
		reset()

func reset():
	material = starting_material.duplicate()
	current_animation = ""
