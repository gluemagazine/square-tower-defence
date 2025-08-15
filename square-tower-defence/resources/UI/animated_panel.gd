extends Panel
class_name PLayerAnimatedPanel

@export var color : Color
@export var animation_resources : Array[PanelAnimation]

var stylebox = StyleBoxFlat.new()
var animation_player : AnimationPlayer

func _ready() -> void:
	add_theme_stylebox_override("panel",stylebox)
	stylebox.bg_color = color
	material = ShaderMaterial.new()
	material.shader = load("uid://chudojcwfpmos").duplicate()
	material.set_shader_parameter("invert",true)
	material.set_shader_parameter("position",Vector2(0.5,0.5))
	material.set_shader_parameter("progress",1)
	material.set_shader_parameter("transition_type",2)
	material.set_shader_parameter("shape_feather",0)
	material.set_shader_parameter("rotation_angle",0)
	print(material.get_shader_parameter("rotation_angle"))
	var library = AnimationLibrary.new()
	for animation in animation_resources:
		var anim = Animation.new()
		anim.loop_mode = 0
		anim.length = animation.duration
		for property in animation.properties:
			var track_index = anim.add_track(Animation.TYPE_VALUE)
			anim.track_set_interpolation_type(track_index,Animation.INTERPOLATION_LINEAR)
			if property.property == "color":
				anim.track_set_path(track_index,"..:stylebox:bg_color")
				anim.track_insert_key(track_index, property.start, property.initial_color)
				anim.track_insert_key(track_index, property.end, property.final_color)
			else:
				anim.track_set_path(track_index, "..:material:%s" %property.property)
				anim.track_insert_key(track_index, property.start, property.initial_value)
				anim.track_insert_key(track_index, property.end, property.final_value)
		library.add_animation(animation.animation_name,anim)
	animation_player = AnimationPlayer.new()
	animation_player.add_animation_library("Global",library)
	add_child(animation_player)
	var callable = print.bind("")
	animation_player.animation_finished.connect(callable)

func play_animation(animation_name):
	animation_player.play("Global/" + animation_name)
