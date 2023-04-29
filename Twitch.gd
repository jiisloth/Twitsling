extends Node

onready var twicil = get_node("TwiCIL")


var NICK = Config.NICK
var CLIENT_ID = Config.CLIENT_ID
var CHANNEL = Config.CHANNEL
var OAUTH = Config.OAUTH

signal bump(integer, character)

# Private methods
func __connect_signals():
    twicil.connect("user_appeared", self, "_on_user_appeared")
    twicil.connect("user_disappeared", self, "_on_user_disappeared")


func _command_reply(params):
    var sender = params[0]
    
    twicil.send_message("Hello, " + str(sender))

func _bump(params):
    var sender = params[0]
    var dir = 90 - randf()*180
    var power = randf() *100
    if len(params) > 1:
        if params[1].is_valid_float():
            dir = float(params[1])
            if dir < -90:
                dir = -90
            if dir > 90:
                dir = 90
    if len(params) > 2:
        if params[2].is_valid_float():
            power = float(params[2])
            if power < 0:
                power = 0
            if power > 100:
                power = 100
    get_parent().shoot(sender, -dir, power)


# Public methods
func join():
    twicil.connect_to_twitch_chat()
    twicil.connect_to_channel(CHANNEL, CLIENT_ID, OAUTH, NICK)


func on_join_message():
    twicil.send_message(str(NICK) + " on täällä tänään!")

func init_interactive_commands():
    twicil.commands.add("!heitä", self, "_bump", 2, true)
    twicil.commands.add("!h", self, "_bump", 2, true)


# Hooks
func _ready():
    if Config.offline:
        return
    __connect_signals()
    init_interactive_commands()
    twicil.set_logging(true)
    join()
    on_join_message()

func send(msg):
    twicil.send_message(msg)

# Events
func _on_user_appeared(name):
    print(name + " Joined")

func _on_user_disappeared(name):
    print(name + " Quit")
