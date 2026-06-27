class_name DiceData
extends Resource



var pool: PoolData

@export var type: Bozo.Dice

@export var values: Array[int] 

var result: int


#region init
func  _init(pool_: PoolData = null) -> void:
	pool = pool_
	
	if pool:
		type = pool.dice_type
		
		init_values()

func init_values() -> void:
	var source = load("res://entities/pool/dice/%s.tres" % Digest.dice_to_string[type])
	values.append_array(source.values)
#endregion

func roll_result() -> void:
	result = values.pick_random()
