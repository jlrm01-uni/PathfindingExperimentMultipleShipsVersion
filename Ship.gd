extends KinematicBody2D

export (String) var ship_name = "Ship " + str(self.get_instance_id())

signal ship_clicked_on

onready var agent = $NavigationAgent2D
onready var sprite = $ShipA
onready var animation_player = $AnimationPlayer

var velocity = Vector2.ZERO
var speed = 800
var target_position = null
var am_I_selected = false
var random_velocity = Vector2.ZERO
var random_speed = 100
onready var timer = $Timer

func _ready():
	randomize()
	timer.start()
	
	yield(owner, "ready")
	
	get_tree().call_group("Level", "connect_ship_signals", self)
	
func _on_Ship_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("ship_clicked_on", self)
			print("Stop clicking on me! It tickles!")

func _physics_process(delta):
#	if not am_I_selected:
#		handle_random_movement(delta)
#		return
		
	if agent.is_navigation_finished():
		print("I found the treasure! Or maybe not...")
		target_position = null
		return
		
	if not target_position:
		return
		
	var next_location = agent.get_next_location()
	var agent_position = global_transform.origin
	
	var direction = agent_position.direction_to(next_location)
	
	velocity = speed * direction
	
	agent.set_velocity(velocity)
	
		
func handle_random_movement(delta):
#	sprite.rotation = safe_velocity.angle() + 90
	random_velocity = move_and_slide(random_velocity)



func _on_Ship_mouse_entered():
	animation_player.play("mouse_over")
	get_tree().call_group("Level", "mouse_over", self)


func _on_Ship_mouse_exited():
	animation_player.play("mouse_exit")
	get_tree().call_group("Level", "mouse_exit", self)

func clicked():
	animation_player.play("selected")
	am_I_selected = true

func _on_NavigationAgent2D_velocity_computed(safe_velocity):
	sprite.rotation = safe_velocity.angle() + 90
	velocity = move_and_slide(safe_velocity)


func _on_Timer_timeout():
	var random_number = randi() % 5

	if random_number == 0:
		random_velocity = Vector2.ZERO
	elif random_number == 1:
		random_velocity = Vector2.LEFT * random_speed
	elif random_number == 2:
		random_velocity = Vector2.UP * random_speed
	elif random_number == 3: 
		random_velocity = Vector2.RIGHT * random_speed
	elif random_number == 4: 
		random_velocity = Vector2.DOWN * random_speed
		
	var next_timer_wait_time = randi() % 2
	
	timer.wait_time = next_timer_wait_time
	timer.start()
	
	print("random velocity: " + str(random_velocity))
	print("next timer at " + str(next_timer_wait_time))
