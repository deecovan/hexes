extends Node

class CardClass extends Object:
	var Name
	var Value = 0
	var Power = 0
	var Health = 0
	
	func _init() -> void:
		## Balancing arrays
		var normal_power        = [3,4,4,3,2,1]
		var normal_health       = [2,3,4,4,3,1]
		var normal_power_value  = [2,1,1,2,2,2]
		var normal_health_value = [2,2,1,1,1,2]
		
		## Prepare values for generator
		var normal_power_sum = 0
		var normal_health_sum = 0
		var normal_power_chances = []
		var normal_health_chances = []
		# Weights sum
		for i in normal_power.size()-1: 
			normal_power_sum += normal_power[i]
			normal_health_sum += normal_health[i]
		# Claculate chances as values/sums
		for i in normal_power.size():
			normal_power_chances.append(
				float(normal_power[i])/float(normal_power_sum))
			normal_health_chances.append(
				float(normal_health[i])/float(normal_health_sum))
		
		## Start generator based on balanced chances
		var power_set = false
		var health_set = false
		var counter = 0
		while power_set == false and health_set == false:
			var power_chance = randf() * 2
			var health_chance = randf() * 2
			counter += 1
			## Break infinite random
			if counter > 999999: 
				printerr("While counter more than 999999!")
				break
			var power_chance_counted = 0
			var health_chance_counted = 0
			## Loop through the chance ranges and find the values
			for i in normal_power.size(): 
				power_chance_counted += normal_power_chances[i]
				health_chance_counted += normal_health_chances[i]
				if not power_set:
					if power_chance < power_chance_counted:
						Power = i
						power_set = true
					else:
						power_chance_counted += normal_power_chances[i]
				if not health_set:
					if health_chance < health_chance_counted:
						Health = i
						health_set = true
					else:
						health_chance_counted += normal_health_chances[i]
						
			## Calculate the Value based on the Power and Health 
			var PowerValueNorn = 1
			var HealthValueNorn = 1
			if Power > 0: 
				PowerValueNorn  = Power * normal_power_value[Power]
			if Health > 0: 
				HealthValueNorn  = Health * normal_health_value[Health]
			var DeNorn = normal_power_value[Power] + normal_health_value[Health]
			if DeNorn == 0:
				DeNorn = 1
			Value = (PowerValueNorn + HealthValueNorn) / DeNorn
			
			## Sometimes the shit happends but i can fix it
			# Just set the minimal values    
			if Value == 0 and power_set and health_set:
				Value = 1
				if Power + Health == 0:
					if normal_power[0] > normal_health[0]:
						Power = 1
					else:
						Health = 1
						
		Name = str(Value) + ": " + str(Power) + "/" + str(Health)


class DeckClass extends Object:
	var Cards = []
	func Draw():
		pass

class PlayerClass extends Object:
	var Id: int
	var Deck = []
	var Hand = []
	var Health = 20
	var DeckSize = 40
	var HandSize = 8
	
var StateController: Node
var Player: PlayerClass
var Opponent: PlayerClass

var card_stats_a = [0,0,0,0,0,0]
var card_stats_d = [0,0,0,0,0,0]
var card_stats_v = [0,0,0,0,0,0]

var tests_finished = false

func _ready() -> void:
	StateController = $StateController
	Player = PlayerClass.new()
	Player.Id = StateController.Owners.User
	Opponent = PlayerClass.new()
	Opponent.Id = StateController.Owners.Opponent
	for i in Player.DeckSize:
		Player.Deck.append(CardClass.new())
	

func _process(_delta: float) -> void:
	match StateController.current_state:
		StateController.GameStates.Starting:
			print_rich("[color=blue]GameStates.Starting")
			var cards = []
			for c in Player.Deck:
				cards.append(c.Name)
				card_stats_v[c.Value] += 1
				card_stats_a[c.Power] += 1
				card_stats_d[c.Health] += 1
			run_tests([cards, card_stats_v, card_stats_a, card_stats_d], true)
			StateController.next_game_state()
		StateController.GameStates.Playing:
			print_rich("[color=blue]GameStates.Playing")
			StateController.next_game_state()
		StateController.GameStates.Ending:
			print_rich("[color=blue]GameStates.Ending")
			StateController.next_game_state()
		StateController.GameStates.Finished:
			pass

func run_tests(_message, _print = false, _force = false) -> void:
	if tests_finished and not _force:
		return
	## Test output
	if _print:
		prints("_______________|Tests for", self.name)
		prints(_message)
	tests_finished = true
