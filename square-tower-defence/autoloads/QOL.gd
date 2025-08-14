extends Node

##returns an attack with the given parameters
func generate_attack(impact,knockback = 0):
	var attack = Attack.new()
	attack.damage = impact
	attack.knockback = knockback
	return attack

var shader : Shader = preload("uid://chudojcwfpmos").duplicate()

##returns a panel that uses the custom shader, 
##access the panel's material to modify it
func create_panel_with_shader(sides,color):
	var panel = Panel.new()
	var panel_texture = StyleBoxFlat.new()
	var material = ShaderMaterial.new()
	material.shader = shader.duplicate()
	
	panel.material = material
	panel.material.set_shader_parameter("edges",sides)
	panel.material.set_shader_parameter("progress",1)
	panel.material.set_shader_parameter("transition_type",2)
	panel.material.set_shader_parameter("position",Vector2(0.5,0.5))
	panel.material.set_shader_parameter("invert",true)
	
	panel_texture.bg_color = color
	panel.add_theme_stylebox_override("panel",panel_texture)
	
	return panel

##sets the engine time scale to a given float
func set_speed_scale(scale : float):
	Engine.time_scale = scale

##default modular_bulet params
var mod_params : Dictionary[String,Variant] = {
	"velocity" = 300,
	"bullet_size" = Vector2(10,10),
	"bullet_color" = Color.GREEN,
	"damage_one" = true,
	"damage" = 1,
	"explode" = false,
	"explosion_radius" = 15,
	"explosion_damage" = 1,
	"explosion_color" = Color.RED,
	"homing" = false
}
