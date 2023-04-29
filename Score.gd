extends Node2D

var txt = ""
var age = 0

func _ready():
    #position += Vector2(randi()%7-3, randi()%3-1)
    $Label.text = txt

func _process(delta):
    age += delta
    position.y -= age/2 -delta
    if age > 0.8:
        modulate.a = 1 - (age-0.8)*5
    if age > 1:
        queue_free()
