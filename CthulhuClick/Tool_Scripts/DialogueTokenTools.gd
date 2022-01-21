tool
extends Node
class_name dialogue_tools
"""
--RUNS PYTHON3 - Dependencies: PyYaml, json--
An intermediate script that can convert yaml files to json and json to yaml files.
Dialogue is stored in a .yaml file for typeability, readibility and quick changes.
.yaml files can't be natively turned to json files though.
This script is a backbone for python scripts that convert them to and from json.

A dialogic timeline (.json) houses all the keys for dialogue such as ">protag_first_call" or ">caller_breathing"
This script can do a few things with this.
It takes the timeline and converts all the keys into a base .yaml tree (Naming -> SceneName:key:dialogue)
All timeline keys are stored in this file, and on each run, these are updated accordingly.
	Options: 
		[Default, Recommended] Update the changed keys and append new scene/keys
		[Deletes dialogue] Fully rewrite the file - not very useful, it's here if needed though
			The 'old' file is renamed with a .yaml.old extension
This .yaml file is ONLY a template file for translations. Each language has its own file (including English).
	e.g. template.yaml		english.yaml		french.yaml 
The language's keys are used to match up with the dialogic timeline keys. This allows easy substitution.

https://godotengine.org/qa/94674/how-you-call-python-script-ingame-receive-console-output-live
"""
const timeline_folder = "res://dialogic/timelines/"
const language_folder = "res://languages/"

func get_all_timelines():
	var output = []
	var exit = OS.execute("python", ["__init__.py"], true, output)
	if exit == OK:
		print(output)


func keys_to_language():
	pass

func get_files():
	pass

func timeline_keys_to_yaml():
	
	pass

# It'd be *mint* if we could grab all the available keys from the dialogic-timelines
# and put them into the language mapping key thing

"""
Note: These are the duplicated timelines, with the language in front of it
var json_file = en-timeline-12345.json
var json_events = json_file["events"]
var timeline_name = json_file["metadata"]["name"]
var english = en.json.keys()
for event in json_events:
	if event.has("text"):
		var key = event["text"]
		if english[timeline_name].has(key) # match it with the translation
			event["text"] = english[timeline_name][key]
	else:
		continue
"""

"""
	"metadata": {
		"dialogic-version": "1.3",
		"file": "timeline-1639299585.json",
		"name": "TELEPHONE"
	}
"""
"""
	"metadata": {
		"dialogic-version": "1.3",
		"file": "timeline-1639299586.json",
		"name": "EN_TELEPHONE"
	}
"""


"""
Should each interaction have it's own dialogue tree?
I was originally thinking this:
Base -> Area -> Character -> Dialogue
			 |-------------> Set flags
but this might be better:
Base -> Area -> Interaction -> Dialogue
			 |---------------> Set flags 
I'm thinking the keys will be like:
	<action> <object> <key>
	interact_TELEPHONE_INTRODUCTION
	interact_TELEPHONE_GOODBYE
Alt:
	<character> <target> <key>
	player_TELEPHONE_INTRODUCTION
	abomination_PLAYER_INTRODUCTION


Converting Godot Area's name to a json key/timeline:
e.g. Area name = Click_Telephone
Click_Telephone -> get_language & -> start Telephone timeline
func redirect_to_language(timeline_string):
	match language:
		ENGLISH:
			return EN_timeline_string
		FRENCH:
			return FR_timeline_string
Before the game is shipped, we do these tool things, and we translate each tree
to the appropriate language, and substitute the keys. These will be stored in their own
duplicate timeline.
"""

"""
Overhead dialogue is a key thing.
Having a .json file for each area?:
	Pros:
		-Easier to see what goes where
		-Easier to maintain (obvious solutions)
		-Can have duplicates in-between areas
			-this isn't really a pro
	Cons:
		-Harder to communicate info between scenes
			-Can be fixed with an intermediate file
			that stores important states
		-Harder to maintain (fragmentation - split up file locations)
		-Translations become harder
			-Can be fixed by keys. e.g. <LANG>_BAKER_HELLO
			-Translations in games are done in one file, I
			would prefer not to fragment them too badly
"""
