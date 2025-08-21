extends Area2D
class_name Explosion

@export var damage : int = 1
@export var one_time : bool = true
@export var panel : Panel

@export_group("automatic setup")
@export var auto : bool = false
@export var radius : int = 15
@export var color : Color = Color.RED

signal exploded
signal finished

func set_params_from_dictionary(dictionary : Dictionary[String,Variant]):
	auto = true
	if dictionary.has("explosion_radius"):
		radius = dictionary["explosion_radius"]
	if dictionary.has("explosion_color"):
		color = dictionary["explosion_color"]
	if dictionary.has("explosion_damage"):
		damage = dictionary["explosion_damage"]

func _ready() -> void:
	set_collision_mask_value(2,true)
	set_collision_layer_value(1,false)
	if auto:
		var collision_shape = CollisionShape2D.new()
		var shape = CircleShape2D.new()
		shape.radius = radius
		collision_shape.shape = shape
		add_child(collision_shape)
		panel = QOL.create_panel_with_shader(50,color)
		add_child(panel)
		panel.hide()
		var resized = radius * 2
		panel.size = Vector2(resized,resized)
		panel.position = Vector2(-radius,-radius)
	if panel:
		panel.material.set_shader_parameter("progress",0.95)

func explode():
	exploded.emit()
	panel.show()
	var attack = QOL.generate_attack(damage)
	for area in get_overlapping_areas():
		if area is HitboxComponent:
			area.damage(attack)
	var tweener = create_tween()
	tweener.tween_property(panel,"self_modulate",Color.TRANSPARENT,1)
	tweener.finished.connect(finished.emit)
