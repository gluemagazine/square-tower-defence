@tool
extends Node2D

func run_animation():
	for child in get_children():
		if child is AnimatedPanel:
			child.play_index(0)
func stop_animation():
	for child in get_children():
		if child is AnimatedPanel:
			child.stop(true)


@export_tool_button("run animations") var call : Callable = self.run_animation.bind()
@export_tool_button("stop animation") var new_call : Callable = self.stop_animation.bind()
