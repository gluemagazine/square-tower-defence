extends Node
class_name WaveManager

@export var spawner_array : Array[ManualSpawner]
var spawners : Dictionary[int,ManualSpawner]
var options = []

@export var waves : Array[Wave] = []
var wave_length : int = 10
var final_wave : bool = false:
	set(new):
		final_wave = new
		if not victory_checker:
			var new_timer : Timer = Timer.new()
			new_timer.wait_time = 1
			add_child(new_timer)
			new_timer.start()
			new_timer.timeout.connect(check_for_victory)
var victory_checker : Timer
var won : bool = false

var current_enemies : Array[Enemy] = []
var current_wave : Wave

var timer : Timer

var wave_timer : Timer

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
	
	wave_timer = Timer.new()
	wave_timer.autostart = true
	wave_timer.wait_time = 2
	wave_timer.timeout.connect(check_for_wave_end.bind(null))
	add_child(wave_timer)
	
	Game.enemy_killed.connect(clear_dead_enemies)

func clear_dead_enemies():
	var to_keep : Array[Enemy] = []
	for enemy in current_enemies:
		if is_instance_valid(enemy):
			to_keep.append(enemy)
	current_enemies = to_keep

func next_wave():
	if current_wave and not current_wave.finished:
		return
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
		current_wave.finished = true
		timer.start()

func check_for_wave_end(erased_enemy):
	if erased_enemy in current_enemies:
		current_enemies.erase(erased_enemy)
	await get_tree().physics_frame
	if current_enemies == [] :
		timer.stop()
		next_wave()
		check_for_victory()
	else:
		print(current_enemies)

func check_for_victory():
	if won:
		return "won"
	if not final_wave:
		return "wrong wave"
	if not current_wave.finished:
		return "not finished"
	if Game.manager.health.health <= 0:
		return "dead"
	if current_enemies == []:
		won = true
		print("victory, change effect later")
		return "victory"
	else:
		clear_dead_enemies()
		return "not caught"

#func test_check():
	#var result = check_for_victory()
	#print(result)
