extends TextureRect

#onready var amount_label = $ItemAmountLabel
#var amount_label = null

#func _init() -> void:
#	amount_label = $ItemAmountLabel

func set_amount_on_label(value):
	var amount_label = $ItemAmountLabel
	if value <= 1:
		amount_label.text = ""
	else:
		amount_label.text = str(value)
