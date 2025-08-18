@tool
extends Node2D

@export var path : String = "res://resources/animations/random stuff/"
@export var resource_name : String = "Testing"

func run_animation():
	for child in get_children():
		if child is AnimatedPanel:
			child.play_index(0)
func stop_animation():
	for child in get_children():
		if child is AnimatedPanel:
			child.stop(true)

func save_animations():
	var animations : Array = []
	for child in get_children():
		if child is AnimatedPanel:
			animations.append(child.create_container())
	var index = 1
	for animation in animations:
		ResourceSaver.save(animation,path + resource_name + "%s.tres" %str(index))
		index += 1

@export_tool_button("save anmiation") var anim_save : Callable = self.save_animations.bind()
@export_tool_button("run animations") var call : Callable = self.run_animation.bind()
@export_tool_button("stop animation") var new_call : Callable = self.stop_animation.bind()
