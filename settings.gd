class_name Settings
extends Resource

enum NumberDisplay {
	SHORTEST, SHORT, NORMAL, LONG, LONGEST
}

@export var number_display: NumberDisplay = NumberDisplay.NORMAL
#@export var number_word_mode = ""
