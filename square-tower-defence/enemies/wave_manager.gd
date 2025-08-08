extends Node
class_name WaveManager

@export var spawner_array : Array[ManualSpawner]
var spawners : Dictionary[int,ManualSpawner]
var options = []

@export var waves : Array[Wave] = []
var wave_length : int = 10
var final_wave : bool = false

var current_enemies : Array[Enemy] = []
var current_wave : Wave

var timer : Timer

func _ready() -> void:
	for i in range(spawner_array.size()):
		spawners[i+1] = spawner_array[i]
	for key in spawners:
		if spawners[key] != null:
			options.append(key)
	timer = Timer.new()
	timer.autostart = false
	timer.one_shot = true
	timer.wait_time = 3
	add_child(timer)
	timer.timeout.connect(next_wave)
	timer.start()

func next_wave():
	if final_wave:
		return
	current_wave = waves.pop_front().duplicate()
	if waves == []:
		final_wave = true
	timer.wait_time = current_wave.duration
	spawn_wave()

func spawn_wave():
	var n_of_spawners = options.size()
	var num_spawned = 0
	var spawn_again : bool = false
	var keep_spawning = false
	for key in current_wave.enemies:
		if spawn_again:
			break
		for i in range(current_wave.enemies[key]):
			if current_wave.enemies[key] <= 0:
				break
			var new_enemy = spawners[max(num_spawned % (n_of_spawners) + 1,1)].spawn(key)
			current_enemies.append(new_enemy)
			new_enemy.killed.connect(check_for_wave_end)
			num_spawned += 1
			current_wave.enemies[key] -= 1
			if num_spawned >= options.size():
				num_spawned -= options.size()
				spawn_again = true
				break
	if spawn_again:
		await get_tree().create_timer(current_wave.spawn_interval).timeout
		spawn_wave()
	else:
		timer.start()


func check_for_wave_end(erased_enemy):
	
	if erased_enemy in current_enemies:
		current_enemies.erase(erased_enemy)
	if current_enemies == []:
		timer.stop()
		spawn_wave()
		if final_wave:
			print("victory, change effect later")
	
