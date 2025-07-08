extends Node

var has_started_timer := false
var time_since_first_jump := 0.0

func reset_timer():
	has_started_timer = false
	time_since_first_jump = 0.0
