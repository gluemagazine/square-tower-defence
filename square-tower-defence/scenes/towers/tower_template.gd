extends Node2D
class_name TowerTemplate

#just me messign around
@export var stats : TowerResource:
	set(new):
		stats = new.duplicate(true)
@export var sightComp:SightComponent
@export var range : CollisionShape2D
@export var range_visual : Panel
@onready var cool_down: Timer = $coolDown
@export var button : Button
@onready var upgrade_button: Button = $upgrade
@onready var sell_button: Button = $sell

var panels : Array[AnimatedPanel]:
	set(new):
		panels = new
		for panel in panels:
			panel.true_duplicate()

var modular_bullet = preload("uid://ig5c4t7spifk")
var locked = false

var on_cooldown = false

signal selected
signal sold

func _ready() -> void:
	QOL.connect_pause_signals(self)
	cool_down.timeout.connect(unlock)
	cool_down.wait_time = stats.cooldown
	range.shape.radius = stats.range_radius
	var radius = stats.range_radius
	range_visual.size = Vector2(radius,radius)
	range_visual.position = Vector2(-radius,-radius)
	
	for panel in stats.panels:
		var instance = AnimatedPanel.new()
		instance.setup_from_container(panel)
		add_child(instance)
		instance.position = - panel.dimentions / 2
		panels.append(instance)
		instance.stop()
	$baseTexture.hide()
	move_child(button,-1)
	cool_down.timeout.connect(set.bind("on_cooldown",false))
	Game.gold_changed.connect(check_gold_for_upgrade)
	if stats.level >= stats.upgrades.size():
		upgrade_button.disabled = true
		upgrade_button.tooltip_text = "Max Level"

func _physics_process(_delta: float) -> void:
	if locked:
		return
	if on_cooldown:
		return
	if sightComp.target:
		var shot : Bullet = modular_bullet.instantiate()
		shot.build_params = stats.bullet_stats
		get_tree().current_scene.add_child(shot)
		shot.global_position = global_position
		shot.dir = (sightComp.target.global_position-global_position).normalized()
		shot.parent_object = self
		if stats.bullet_stats["set_target"] or stats.bullet_stats["homing"]:
			shot.set_target = sightComp.target
			sightComp.target_changed.connect(shot.set_new_target)
		for panel in panels:
			panel.play_animation("fire")
		cool_down.start()
		on_cooldown = true

func upgrade():
	if Game.gold >= stats.upgrades[stats.level].cost:
		Game.gold -= stats.upgrades[stats.level].cost
	else:
		return
	for panel in panels:
		panel.level_up()
	stats.upgrades[stats.level].apply(stats)
	stats.level += 1
	cool_down.wait_time = stats.cooldown
	var radius = stats.range_radius
	range_visual.size = Vector2(radius,radius)
	range_visual.position = Vector2(-radius,-radius)
	if stats.level >= stats.upgrades.size():
		upgrade_button.disabled = true
		upgrade_button.tooltip_text = "Max Level"
	

func lock():
	locked = true
	cool_down.paused = true
func unlock():
	locked = false
	cool_down.paused = false

func show_range():
	range_visual.show()
func hide_range():
	range_visual.hide()

func _on_button_pressed() -> void:
	selected.emit()
	open()

func open():
	sell_button.show()
	upgrade_button.show()
	show_range()
func close():
	hide_range()
	sell_button.hide()
	upgrade_button.hide()

func _on_upgrade_pressed() -> void:
	upgrade()
	if not stats.level >= stats.upgrades.size():
		upgrade_button.tooltip_text = stats.upgrades[stats.level].description
	else:
		upgrade_button.disabled = true
		upgrade_button.tooltip_text = "Max Level"

func check_gold_for_upgrade():
	await get_tree().physics_frame
	if not stats.next_upgrade:
		return
	if Game.gold >= stats.next_upgrade.cost:
		upgrade_button.disabled = false
	else:
		upgrade_button.disabled = true

func _on_sell_pressed() -> void:
	Game.add_gold(stats.get_refund())
	queue_free()
	sold.emit()
