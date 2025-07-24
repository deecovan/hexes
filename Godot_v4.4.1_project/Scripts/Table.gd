extends Node

class HexClass extends Object:
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
	var Hexes = []
	var hex = null
	
	func Draw() -> HexClass:
		if Hexes.size() > 0:
			hex = Hexes[0]
			Hexes.erase(hex)
		else:
			## Deck is empty! Signal GameOver!
			printerr("Deck is empty! Signal GameOver!")
		return hex
	
	func getNames(hexes = Hexes) -> Array:
		var a = []
		for h in hexes:
			a.append(h.Name)
		return a

class PlayerClass extends Object:
	var Id: int
	var Deck = DeckClass.new()
	var Health = 20
	var DeckSize = 60
	var HandSize = 6
	var MaxHandSize = 8
	
	var Hand = []
			
	var HandHash: int
	
	func _init() -> void:
		HandHash = hash(Hand)
		
	func emitHandChanged():
		if HandHash != hash(Hand):
			HandHash = hash(Hand)
			print_rich("[i]emitHandChanged()")
			## Emit Hand Changed
			
	func emitHandOverdraw():
		print_rich("[i]emitHandOverdraw()")
		## Emit Hand Overdraw
		
var StateController: Node
var Player: PlayerClass
var Opponent: PlayerClass
var turn_owner: PlayerClass
var turn_state

var hex_stats_a = [0,0,0,0,0,0]
var hex_stats_d = [0,0,0,0,0,0]
var hex_stats_v = [0,0,0,0,0,0]

var tests_finished = false

func _ready() -> void:
	StateController = $StateController
	Player = PlayerClass.new()
	Player.Id = StateController.Owners.User
	Opponent = PlayerClass.new()
	Opponent.Id = StateController.Owners.Opponent
	## Starting Player
	turn_owner = Player
	turn_state = StateController.TurnStates.BeginTurn
	for i in Player.DeckSize:
		Player.Deck.Hexes.append(HexClass.new())

func _process(_delta: float) -> void:
	
	match StateController.current_state:
		
		StateController.GameStates.Starting:
			print_rich("now... [color=blue]Starting")
			var hexes = []
			for c in Player.Deck.Hexes:
				hexes.append(c.Name)
				hex_stats_v[c.Value] += 1
				hex_stats_a[c.Power] += 1
				hex_stats_d[c.Health] += 1
			run_tests([hexes, hex_stats_v, hex_stats_a, hex_stats_d], true)
			## First Shuffle
			print_rich("[b]Shuffle...")
			Player.Deck.Hexes.shuffle()
			## Than Draw starting Hand
			print_rich("[b]Draw " + str(Player.HandSize) + "...")
			for i in Player.HandSize:
				Player.Hand.append(Player.Deck.Draw())
				Player.emitHandChanged()
			print(Player.Deck.getNames(Player.Hand))
			StateController.emitNextGameState()
			
		StateController.GameStates.Playing:
			print_rich("now... [color=blue]Playing")
			## Add Turns implementation from here
			var owner_key = StateController.Owners.find_key(turn_owner.Id)
			var state_key = StateController.TurnStates.find_key(turn_state)
			prints("Owner:", owner_key)
			prints("State:", state_key)
			
			match turn_state:
				StateController.TurnStates.BeginTurn:
					## Untap
					print_rich("[i]Rotate...")
					## Add Coins
					print_rich("[i]Add coins...")
					turn_state = StateController.TurnStates.DrawHex
					
				StateController.TurnStates.DrawHex:
					## Draw a card
					print_rich("[i]Player.Hand.append(Player.Deck.Draw())")
					Player.Hand.append(Player.Deck.Draw())
					Player.emitHandChanged()
					## Next StateController.TurnStates. Play Hex, 
					# ......
					## Simulate Too many cards drawn
					if Player.Hand.size() > Player.MaxHandSize:
						Player.emitHandOverdraw()
						print(Player.Deck.getNames(Player.Hand))
						turn_state = StateController.TurnStates.EndTurn
						
				StateController.TurnStates.EndTurn:
					StateController.emitNextGameState()
			
		StateController.GameStates.Ending:
			print_rich("now... [color=blue]Ending")
			StateController.emitNextGameState()
			
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
