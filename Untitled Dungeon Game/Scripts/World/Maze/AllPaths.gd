extends Node

var oooo = load("res://Scenes/World/Maze/oooo.tscn")
var iooo = load("res://Scenes/World/Maze/iooo.tscn")
var oioo = load("res://Scenes/World/Maze/oioo.tscn")
var ooio = load("res://Scenes/World/Maze/ooio.tscn")
var oooi = load("res://Scenes/World/Maze/oooi.tscn")
var iiii = load("res://Scenes/World/Maze/Closed.tscn")

var front_paths = [oooo, oooo, oooo, iooo, oioo, ooio]
var left_paths = [oooo, oooo, oooo, iooo, oioo, oooi]
var right_paths = [oooo, oooo, oooo, iooo, ooio, oooi]
var back_paths = [oooo, oooo, oooo, oioo, ooio, oooi]

func _ready():
	print("All paths gucci")
