class_name PoolData
extends Resource


var encounter: EncounterData

var dices: Array[DiceData]

var dice_type: Bozo.Dice = Bozo.Dice.CLAW
var circumstance: Bozo.Circumstance

var pressure: int = 0
var result: int = 0


#region init
func _init(encounter_: EncounterData) -> void:
	encounter = encounter_
	
	refill_dices()
	#var a = 4
	#var b = 9
	#var stats = monte_carlo_analysis(20000, 4, 9)
#
	#print("Вероятность результата <= %d: %.2f%%" % [a, stats["sectors"]["sector_1"]["percentage"]])
	#print("Вероятность результата %d-%d: %.2f%%" % [a+1, b, stats["sectors"]["sector_2"]["percentage"]])
	#print("Вероятность результата >= %d: %.2f%%" % [b+1, stats["sectors"]["sector_3"]["percentage"]])

	
	var stats = monte_carlo_analysis(10000)

	print("Среднее значение: %.2f" % stats["average"])
	print("Диапазон: %d - %d" % [stats["min"], stats["max"]])
	print("Стандартное отклонение: %.2f" % stats["std_dev"])
	print("Распределение: ", stats["distribution"])
	print("Вероятности: ", stats["probability"])

func refill_dices() -> void:
	dices.clear()
	var n = Catalog.POOL_DICE_COUNT + pressure
	
	for _i in n:
		add_dice()

func add_dice() -> void:
	var dice = DiceData.new(self)
	dices.append(dice)
#endregion

#region roll
func roll_result() -> void:
	
	for dice in dices:
		dice.roll_result()
	
	dices.sort_custom(func (a, b): return circumstance_sort(a, b))
	
	calc_result()

func circumstance_sort(a_: DiceData, b_: DiceData) -> bool:
	match circumstance:
		Bozo.Circumstance.DOMINANCE:
			return a_.result > b_.result
		Bozo.Circumstance.HINDRANCE:
			return a_.result < b_.result
	
	return true

func calc_result() -> void:
	result = 0
	
	for _i in Catalog.POOL_DICE_COUNT:
		var dice = dices[_i]
		result += dice.result
#endregion
#
##region monte_carlo
#func monte_carlo_analysis(iterations: int = 10000) -> Dictionary:
	#"""Симулирует множество бросков и собирает статистику"""
	#var results: Array[int] = []
	#
	#for _i in iterations:
		## Используем текущий пул, просто перебрасываем кубы
		#roll_result()
		#results.append(result)
	#
	#return _analyze_results(results)
#
#func _analyze_results(results: Array[int]) -> Dictionary:
	#"""Вычисляет статистику результатов"""
	#if results.is_empty():
		#return {}
	#
	#var sum = 0
	#var min_val = results[0]
	#var max_val = results[0]
	#var distribution: Dictionary = {}
	#
	#for value in results:
		#sum += value
		#min_val = mini(min_val, value)
		#max_val = maxi(max_val, value)
		#
		#if not distribution.has(value):
			#distribution[value] = 0
		#distribution[value] += 1
	#
	#var average = float(sum) / results.size()
	#var variance = 0.0
	#
	#for value in results:
		#variance += pow(value - average, 2)
	#variance /= results.size()
	#
	#return {
		#"iterations": results.size(),
		#"min": min_val,
		#"max": max_val,
		#"average": average,
		#"std_dev": sqrt(variance),
		#"distribution": distribution,
		#"probability": _calculate_probability(distribution, results.size())
	#}
#
#func _calculate_probability(distribution: Dictionary, total: int) -> Dictionary:
	#"""Конвертирует распределение в вероятности"""
	#var probabilities: Dictionary = {}
	#for value in distribution.keys():
		#probabilities[value] = float(distribution[value]) / total
	#return probabilities
##endregion

#region monte_carlo
func monte_carlo_analysis(iterations: int = 10000, a: int = 0, b: int = 0) -> Dictionary:
	"""Симулирует множество бросков и собирает статистику с анализом диапазонов"""
	var results: Array[int] = []
	
	for _i in iterations:
		roll_result()
		results.append(result)
	
	return _analyze_results(results, a, b)

func _analyze_results(results: Array[int], a: int, b: int) -> Dictionary:
	"""Вычисляет статистику результатов и вероятности по секторам"""
	if results.is_empty():
		return {}
	
	var sum = 0
	var min_val = results[0]
	var max_val = results[0]
	var distribution: Dictionary = {}
	
	# Счетчики для секторов
	var sector1_count = 0  # <= a
	var sector2_count = 0  # a+1 до b
	var sector3_count = 0  # >= b+1
	
	for value in results:
		sum += value
		min_val = mini(min_val, value)
		max_val = maxi(max_val, value)
		
		if not distribution.has(value):
			distribution[value] = 0
		distribution[value] += 1
		
		# Распределение по секторам
		if value <= a:
			sector1_count += 1
		elif value >= a + 1 and value <= b:
			sector2_count += 1
		elif value >= b + 1:
			sector3_count += 1
	
	var average = float(sum) / results.size()
	var variance = 0.0
	
	for value in results:
		variance += pow(value - average, 2)
	variance /= results.size()
	
	var total = float(results.size())
	
	return {
		"iterations": results.size(),
		"min": min_val,
		"max": max_val,
		"average": average,
		"std_dev": sqrt(variance),
		"distribution": distribution,
		"probability": _calculate_probability(distribution, results.size()),
		"sectors": {
			"sector_1": {
				"description": "Результат <= %d" % a,
				"count": sector1_count,
				"probability": sector1_count / total,
				"percentage": (sector1_count / total) * 100
			},
			"sector_2": {
				"description": "Результат от %d до %d" % [a + 1, b],
				"count": sector2_count,
				"probability": sector2_count / total,
				"percentage": (sector2_count / total) * 100
			},
			"sector_3": {
				"description": "Результат >= %d" % (b + 1),
				"count": sector3_count,
				"probability": sector3_count / total,
				"percentage": (sector3_count / total) * 100
			}
		}
	}

func _calculate_probability(distribution: Dictionary, total: int) -> Dictionary:
	"""Конвертирует распределение в вероятности"""
	var probabilities: Dictionary = {}
	for value in distribution.keys():
		probabilities[value] = float(distribution[value]) / total
	return probabilities
#endregion
