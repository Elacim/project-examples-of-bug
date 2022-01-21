extends Node
#class_name logger

enum SEVERITY {
	WARNING = 0,
	ERROR = 1,
	FATAL_ERROR = 2
	NULL_TIMELINE = 3
}
var keys = SEVERITY.keys()

func log_event(event: String, object: Object, function: String, severity: int):
	if event and object and function and severity:
		var logged = "[%s] [%s - LOG] '%s' happened @ %s (%s). Function: %s"
		logged = logged % [get_time(), keys[severity],  event, object, object.name, function]

func get_time():
	var time = OS.get_time()
	var date = OS.get_date()
	# if date is different to previous date, log the new date, if not, skip adding the date
	return "%s-%s-%s | %s:%s:%s" % [date["year"], date["month"], date["day"], time["hour"], time["minute"], time["second"]]

# We need to add a write to file thing that logs everything

