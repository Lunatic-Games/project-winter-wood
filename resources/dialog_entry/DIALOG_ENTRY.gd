extends Resource

enum DIALOG_TYPES {
	dialog,
	choice
}

class_name DIALOG_ENTRY

export (DIALOG_TYPES) var type = DIALOG_TYPES.dialog
export (Texture) var portrait
export (String) var text = "Sample text, enter the text here"
export (String) var short_text = "Text displayed for choices"
export (Array, Resource) var entry_references = []
export (Array, Resource) var choices = []

# Function to return the correct entry from their reference list, being given the number for the choice that was made
# IE choice 1 leads to entry 1, choice 2 leads to entry 2 etc
#func get_next_entry():
#	pass
