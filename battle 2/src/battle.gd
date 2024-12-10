extends Control  # or any other appropriate base class
@onready var enemy_hp_bar = $ENEMYHP
@onready var char_hp_bar = $CharHP
@onready var char_dmg_sfx = $DMGCHAR
@onready var enemy_dmg_sfx = $DMGENEMY
@onready var message_dialog = $USEDBOX
var charhp: int = 100
var enemy_health: int = 100 
var used_words: Dictionary = {}
var target_strings: Dictionary = {
	"DELI": 8,
	"DIRE": 12,
	"DRIZZLE": 26,
	"IDLE": 9,
	"LIED": 11,
	"RIDE": 13,
	"RILE": 7,
	"RILED": 14,
	"IDLER": 25,
	"IRED":50,
	"LIER":25
}
func _ready() -> void:
	enemy_hp_bar.max_value = enemy_health  # Set the maximum value of the enemy's ProgressBar
	enemy_hp_bar.value = enemy_health  # Set the initial value of the enemy's ProgressBar
	char_hp_bar.max_value = charhp  # Set the maximum value of the character's ProgressBar
	char_hp_bar.value = charhp  
	$DELILABEL.visible = false
	$DIRELABEL.visible = false
	$DRIZZLELABEL.visible = false
	$IDLELABEL.visible = false
	$LIEDLABEL.visible = false
	$RIDELABEL.visible = false
	$RILEDLABEL.visible = false
	$RILELABEL.visible = false
	$IDLERLABEL.visible = false
	$IREDLABEL.visible = false
	$LIERLABEL.visible = false
func _process(delta: float) -> void:
	pass

#BUTTONS CODE
func _on_button_d_pressed() -> void:
	var line_edit = $LineEdit  
	line_edit.text += "D"
	$ButtonD.disabled = true
	$CLICK.play()
func _on_button_z_pressed() -> void:
	var line_edit = $LineEdit  
	line_edit.text += "Z"
	$ButtonZ.disabled = true
	$CLICK.play()
func _on_button_r_pressed() -> void:
	var line_edit = $LineEdit  
	line_edit.text += "R"
	$ButtonR.disabled = true
	$CLICK.play()
func _on_button_e_pressed() -> void:
	var line_edit = $LineEdit  
	line_edit.text += "E"
	$ButtonE.disabled = true
	$CLICK.play()
func _on_button_z_2_pressed() -> void:
	var line_edit = $LineEdit  
	line_edit.text += "Z"
	$ButtonZ2.disabled = true
	$CLICK.play()
func _on_button_i_pressed() -> void:
	var line_edit = $LineEdit  
	line_edit.text += "I"
	$ButtonI.disabled = true
	$CLICK.play()
func _on_button_l_pressed() -> void:
	var line_edit = $LineEdit  
	line_edit.text += "L"
	$ButtonL.disabled = true
	$CLICK.play()
func _on_button_clr_pressed() -> void:
	var line_edit = $LineEdit  # Reference to the LineEdit node
	var current_text = line_edit.text
	$CLRSD.play()
	if current_text.length() > 0:
		var last_char = current_text[current_text.length() - 1]  # Get the last character
		line_edit.text = current_text.substr(0, current_text.length() - 1)  # Remove the last character
		match last_char:
			"D":
				$ButtonD.disabled = false
			"R":
				$ButtonR.disabled = false
			"Z":
				if current_text.length() > 0 and current_text[current_text.length() - 1] == "Z":
					if current_text.count("Z") == 1:
						$ButtonZ.disabled = false
					elif current_text.count("Z") == 2:
						$ButtonZ2.disabled = false
			"I":
				$ButtonI.disabled = false
			"L":
				$ButtonL.disabled = false
			"E":
				$ButtonE.disabled=false
				
func _on_button_atk_pressed() -> void:
	var line_edit = $LineEdit
	var current_text = line_edit.text.strip_edges()  # Get the current text in the LineEdit and trim whitespace

	# Check if LineEdit is empty
	if current_text == "":
		show_message("Enter A Word First")  # Show message if no input
		return  # Do nothing if LineEdit is empty

	check_for_match()  # Proceed with checking for a match if there's input
	$LineEdit.text = ""  # Clear the LineEdit
	enable_input_buttons()  # Re-enable the input buttons for the next attack
	print("attack")
func enable_input_buttons() -> void:
	$ButtonD.disabled = false
	$ButtonZ.disabled = false
	$ButtonR.disabled = false
	$ButtonE.disabled = false
	$ButtonZ2.disabled = false
	$ButtonI.disabled = false
	$ButtonL.disabled = false # Replace with function body.
func _on_button_d_mouse_entered() -> void:
	if not $ButtonD.disabled:
		$HOVER.play()
func _on_button_z_mouse_entered() -> void:
	if not $ButtonZ.disabled:
		$HOVER.play()
func _on_button_r_mouse_entered() -> void:
	if not $ButtonR.disabled:
		$HOVER.play()
func _on_button_i_mouse_entered() -> void:
	if not $ButtonI.disabled:
		$HOVER.play()
func _on_button_z_2_mouse_entered() -> void:
	if not $ButtonZ2.disabled:
		$HOVER.play()
func _on_button_e_mouse_entered() -> void:
	if not $ButtonE.disabled:
		$HOVER.play()
func _on_button_l_mouse_entered() -> void:
	if not $ButtonL.disabled:
		$HOVER.play()
func _on_button_clr_mouse_entered() -> void:
	$HOVER.play()
func _on_button_atk_mouse_entered() -> void:
	$HOVER.play()

#HP DMG CODE
func take_damage(amount: int) -> void:
	enemy_health -= amount
	enemy_health = clamp(enemy_health, 0, enemy_hp_bar.max_value)  # Ensure health doesn't go below 0
	enemy_hp_bar.value = enemy_health
	enemy_dmg_sfx.play()  # Update the ProgressBar value
	if enemy_health <= 0:
		pass  # Call a function to handle enemy death
	update_health_display()

func update_health_display() -> void:
	print("Enemy health: ", enemy_health)

func check_for_match() -> void:
	var line_edit = $LineEdit
	var current_text = line_edit.text.strip_edges()  # Get the current text in the LineEdit and trim whitespace

	# Check if the word has already been used
	if used_words.has(current_text):
		print("Word already used")
		show_message("Word already used")  # Show the message in the dialog
		return  # Do nothing if the word is already used

	# Check if the word matches one in target_strings
	if current_text in target_strings:
		print("Match")
		var damage = target_strings[current_text]  # Get the damage value for the matched word
		take_damage(damage)  # Call take_damage with the damage value
		used_words[current_text] = true  # Mark the word as used
		target_strings.erase(current_text)  # Remove the word from the dictionary
		
		# Now show the correct label based on the matched word
		match current_text:
			"DELI":
				$DELILABEL.visible = true
			"DIRE":
				$DIRELABEL.visible = true
			"DRIZZLE":
				$DRIZZLELABEL.visible = true
			"IDLE":
				$IDLELABEL.visible = true
			"LIED":
				$LIEDLABEL.visible = true
			"RIDE":
				$RIDELABEL.visible = true
			"RILED":
				$RILEDLABEL.visible = true
			"RILE":
				$RILELABEL.visible = true
			"IDLER":	
				$IDLERLABEL.visible = true
			"IRED":	
				$IREDLABEL.visible = true
			"LIER":	
				$LIERLABEL.visible = true
	else:
		print("Not Match")
		take_character_damage(20)

# Function to show the message in the popup dialog
func show_message(message: String) -> void:
	message_dialog.get_child(0).text = message  # Set the label's text inside the dialog (Assuming the dialog has a Label)
	message_dialog.popup_centered()

func take_character_damage(amount: int) -> void:
	charhp -= amount
	charhp = max(charhp, 0)  # Ensure character health doesn't go below 0
	char_hp_bar.value = charhp  # Update the character's ProgressBar value
	char_dmg_sfx.play()
	print("Character health: ", charhp)
