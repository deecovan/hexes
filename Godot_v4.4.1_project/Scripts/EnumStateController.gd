extends Node

enum Owners {
	Player,
	Opponent
}
enum States {
	BeginTurn,
	DrawHex,
	EndTurn
}
var turn_sequence = []
var current_stage = 0

func _ready() -> void:
	for own in Owners:
		for stt in States:
			turn_sequence.append([own, stt])
	## Test output
	prints("Turn sequence:", turn_sequence)
	prints("Random  stage:", get_stage_data(randi_range(-10,10)))
	prints("Current stage:", get_stage_data(current_stage))
	prints("Prev.   stage:", get_stage_data(current_stage-1))
	prints("Next    stage:", get_stage_data(current_stage+1))
	## Start Turn Sequence from current_stage: 
	#- ...Start Turn Sequence from current_stage: 
	  #- PLAYER BEGIN_TURN
	  #- Pass to DRAW_HEX
	#- ...Add principal Draw
	  #- Deck in TablePart 2
	  #- Draw a Hex on Draw Stage 
	
func get_stage_data(stage: int) -> Dictionary:
	print("get_stage_data(stage=" + str(stage) + ")")
	## Prevent Array Out of index error
	while stage < 0:
		stage += turn_sequence.size()
	while stage > turn_sequence.size() - 1:
		stage -= turn_sequence.size()
	return {
		"Owner": turn_sequence[stage][0],
		"State": turn_sequence[stage][1],
	}
