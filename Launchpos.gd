extends Sprite


func _on_Timer_timeout():
    frame = abs(frame - 1)
