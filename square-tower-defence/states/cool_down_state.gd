extends State
class_name CoolDownState

@export var timer:Timer
@export var coolDown:float = 1
@export var nextState:State

func _ready() -> void:
	timer.timeout.connect(finished)

func enter()->void:
	timer.start(coolDown)

func finished()->void:
	emit_signal("transitioned",self,nextState.name)
