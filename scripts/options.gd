class_name Options

static var instance: Options = null

enum Difficulty_type {
	EASY = 1,
	MEDIUM,
	HARD
}

var music: bool = true
var sfx: bool = true
var difficulty: Difficulty_type = Difficulty_type.EASY

static func get_instance() -> Options:
	if instance == null:
		instance = Options.new()
	return instance
	
func decrease_difficulty():
	if difficulty > Difficulty_type.EASY:
		difficulty -= 1 as Difficulty_type
		
func increase_difficulty():
	if difficulty < Difficulty_type.HARD:
		difficulty += 1 as Difficulty_type
		
func get_difficulty() -> String:
	match difficulty:
		Difficulty_type.EASY:
			return "Piece of cake"
		Difficulty_type.MEDIUM:
			return "Brave dude"
		Difficulty_type.HARD:
			return "Reckless"
		_:
			return str(difficulty)
