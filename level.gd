extends Node2D

var current_ship: KinematicBody2D = null

var mouse_is_over_ship = null

func _ready():
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("Clicked on screen!")
			
			var real_position = get_global_mouse_position()
			setup_target_position(real_position)
			
func setup_target_position(position):
	if not current_ship:
		print("Please click on a ship first, dude (or dudette).")
		return
		
	if not mouse_is_over_ship:
		current_ship.target_position = position
		current_ship.agent.set_target_location(position)
		
func connect_ship_signals(instance):
	instance.connect("ship_clicked_on", self, "on_ship_clicked")
	
func on_ship_clicked(instance):
	current_ship = instance
	current_ship.clicked()
	print(current_ship)
	
func mouse_over(instance):
	mouse_is_over_ship = instance
	
func mouse_exit(instance):
	mouse_is_over_ship = null
