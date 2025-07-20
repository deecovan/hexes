extends Node

enum Owners {
	User,
	Opponent
}
enum TurnStates {
	BeginTurn,
	DrawHex,
	EndTurn
}
enum GameStates {
	Starting = 0,
	Playing,
	Ending
}
var turn_sequence = []
var current_stage = GameStates.Starting
var tests_finished = false

func _ready() -> void:
	## Init Turn sequence
	for own in Owners:
		for tst in TurnStates:
			turn_sequence.append([own, tst])
	run_tests(turn_sequence, false)
	
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

func run_tests(_message, _print = false, _force = false) -> void:
	if tests_finished and not _force:
		return
	## Test output
	if _print:
		prints("_______________|Tests for", self.name)
		prints(_message)
		prints("Random  stage:", get_stage_data(randi_range(-10,10)))
		prints("Current stage:", get_stage_data(current_stage))
		prints("Prev.   stage:", get_stage_data(current_stage-1))
		prints("Next    stage:", get_stage_data(current_stage+1))
	tests_finished = true
