extends Node2D

var stats = {}

func x():
	return 'Hola'

func _ready():
	stats = $StatsManager.getStats()
	if stats && typeof(stats) == 18:
		
		print('El nivel es:', stats.level)
		var newStats = stats
		newStats.level = 50
		$StatsManager.updateStats(newStats)
