extends Node 
class_name StateMachine

var stateDict:Dictionary
var currentState:State
@export var baseState:State

func _ready()->void:
	for i:Node in get_children():
		if i is State:
			stateDict[i.name.to_lower()] = i
			i.transitioned.connect(on_child_transition)
	currentState = baseState
	currentState.enter()

func _process(delta:float)->void:
	if currentState:
		currentState.update(delta)

func _physics_process(delta:float)->void:
	if currentState:
		currentState.physicsUpdate(delta)

func on_child_transition(state:State,newStateName:String)->void:
	if state != currentState:
		return
	var newState:State = stateDict.get(newStateName.to_lower())
	if currentState:
		currentState.exit()
	currentState = newState
	newState.enter()
