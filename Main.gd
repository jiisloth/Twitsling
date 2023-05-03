extends Node2D

var adminshoot = false

func _ready():
	randomize()
	set_level_name()
	

func shoot(sender, dir, power, admin=false):
	if not Global.paused:
		if not Global.check_active(sender):
			$Level.shoot(sender, dir, power)
			if admin and Config.allow_admin_spam:
				Global.set_inactive(sender)
			else:
				Global.set_active(sender)


func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		if Global.paused:
			Global.paused = false
			$PauseScreen.hide()
		else:
			Global.paused = true
			adminshoot = false
			$PauseScreen.show()
	if Input.is_action_just_pressed("shoot"):
		
		if not Global.paused:
			if adminshoot:
				var mouse = get_viewport().get_mouse_position()
				var diff = $Level.launchpos - mouse
				var dir = rad2deg(diff.angle())-180
				if dir <= -180:
					dir += 360
				var power = min(diff.length(), 100)
				print("Admin shot: d: ", -dir, " p: ", power)
				shoot("<!> Admin", dir, power, true)
			else:
				adminshoot = true
			
func set_level_name():
	var lvl = $Level.lvl.name
	lvl = Array(lvl.split("_"))
	var creator = lvl.pop_back()
	var lvlname = " ".join(lvl)
	$UI2/LVLinfo.text = lvlname + "\n- " + creator
			   

func _on_Continue_gui_input(event):
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		Global.paused = false
		$PauseScreen.hide()


func _on_Previous_gui_input(event):
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		$Level.set_level(-1)
		set_level_name()


func _on_Next_gui_input(event):
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		$Level.set_level(1)
		set_level_name()
