extends Control
  # or any other appropriate base class
@onready var enemy_hp_bar = $ENEMYHP
@onready var char_hp_bar = $CharHP
@onready var char_dmg_sfx = $DMGCHAR
@onready var enemy_dmg_sfx = $DMGENEMY
@onready var message_dialog = $USEDBOX
@onready var animation_player = $AnimationPlayer  # Reference to the MessageDialog node
var charhp: int = 100
var enemy_health: int = 100  # Example starting health
var used_words: Dictionary = {}
var target_strings: Dictionary = {
	"WARRIOR": 22,
	"AIR": 5,
	"ARROW": 15,
	"OAR": 12,
	"RAW": 8,
	"ROAR": 14,
	"ROW": 6,
	"WAR": 18
}

func _ready() -> void:
	enemy_hp_bar.max_value = enemy_health  # Set the maximum value of the enemy's ProgressBar
	enemy_hp_bar.value = enemy_health  # Set the initial value of the enemy's ProgressBar
	char_hp_bar.max_value = charhp  # Set the maximum value of the character's ProgressBar
	char_hp_bar.value = charhp  
	$WARRIORLABEL.visible = false
	$AIRLABEL.visible = false
	$ARROWLABEL.visible = false
	$OARLABEL.visible = false
	$RAWLABEL.visible = false
	$ROARLABEL.visible = false
	$ROWLABEL.visible = false
	$WARLABEL.visible = false
	$SLASH.visible = false
func _process(delta: float) -> void:
	pass
#BUTTONS CODE
func _on_button_a_pressed() -> void:
	var line_edit = $LineEdit  
	line_edit.text += "A"
	$ButtonA.disabled = true
	$CLICK.play()
func _on_button_w_pressed() -> void:
	var line_edit = $LineEdit  
	line_edit.text += "W"
	$ButtonW.disabled = true
	$CLICK.play()
func _on_button_r_1_pressed() -> void:
	var line_edit = $LineEdit  
	line_edit.text += "R"
	$ButtonR1.disabled = true
	$CLICK.play()
func _on_button_r_2_pressed() -> void:
	var line_edit = $LineEdit  
	line_edit.text += "R"
	$ButtonR2.disabled = true
	$CLICK.play()
func _on_button_r_3_pressed() -> void:
	var line_edit = $LineEdit  
	line_edit.text += "R"
	$ButtonR3.disabled = true
	$CLICK.play()
func _on_button_i_pressed() -> void:
	var line_edit = $LineEdit  
	line_edit.text += "I"
	$ButtonI.disabled = true
	$CLICK.play()
func _on_button_o_pressed() -> void:
	var line_edit = $LineEdit  
	line_edit.text += "O"
	$ButtonO.disabled = true
	$CLICK.play()
func _on_button_clr_pressed() -> void:
	var line_edit = $LineEdit  # Reference to the LineEdit node
	var current_text = line_edit.text
	$CLRSD.play()
	if current_text.length() > 0:
		var last_char = current_text[current_text.length() - 1]  # Get the last character
		line_edit.text = current_text.substr(0, current_text.length() - 1)  # Remove the last character
		match last_char:
			"A":
				$ButtonA.disabled = false
			"W":
				$ButtonW.disabled = false
			"R":
				if current_text.length() > 0 and current_text[current_text.length() - 1] == "R":
					if current_text.count("R") == 1:
						$ButtonR1.disabled = false
					elif current_text.count("R") == 2:
						$ButtonR2.disabled = false
					elif current_text.count("R") == 3:
						$ButtonR3.disabled = false
			"I":
				$ButtonI.disabled = false
			"O":
				$ButtonO.disabled = false
				
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
	$ButtonA.disabled = false
	$ButtonW.disabled = false
	$ButtonR1.disabled = false
	$ButtonR2.disabled = false
	$ButtonR3.disabled = false
	$ButtonI.disabled = false
	$ButtonO.disabled = false # Replace with function body.
func _on_button_a_mouse_entered() -> void:
	if not $ButtonA.disabled:
		$HOVER.play()
func _on_button_w_mouse_entered() -> void:
	if not $ButtonW.disabled:
		$HOVER.play()
func _on_button_r_2_mouse_entered() -> void:
	if not $ButtonR2.disabled:
		$HOVER.play()
func _on_button_i_mouse_entered() -> void:
	if not $ButtonI.disabled:
		$HOVER.play()
func _on_button_r_1_mouse_entered() -> void:
	if not $ButtonR1.disabled:
		$HOVER.play()
func _on_button_o_mouse_entered() -> void:
	if not $ButtonO.disabled:
		$HOVER.play()
func _on_button_r_3_mouse_entered() -> void:
	if not $ButtonA.disabled:
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
			"WARRIOR":
				$WARRIORLABEL.visible = true
			"AIR":
				$AIRLABEL.visible = true
			"ARROW":
				$ARROWLABEL.visible = true
			"OAR":
				$OARLABEL.visible = true
			"RAW":
				$RAWLABEL.visible = true
			"ROAR":
				$ROARLABEL.visible = true
			"ROW":
				$ROWLABEL.visible = true
			"WAR":
				$WARLABEL.visible = true

	else:
		print("Not Match")
		take_character_damage(20)

# Function to show the message in the popup dialog
func show_message(message: String) -> void:
	message_dialog.get_child(0).text = message  # Set the label's text inside the dialog (Assuming the dialog has a Label)
	message_dialog.popup_centered()  # Show the dialog centered
func take_character_damage(amount: int) -> void:
	charhp -= amount
	charhp = max(charhp, 0)  # Ensure character health doesn't go below 0
	char_hp_bar.value = charhp  # Update the character's ProgressBar value
	char_dmg_sfx.play()
	print("Character health: ", charhp)
