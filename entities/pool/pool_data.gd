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
