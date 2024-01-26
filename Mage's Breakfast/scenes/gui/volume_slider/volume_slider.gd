extends HSlider

@export var bus_name: String

@onready var bus_id: int = AudioServer.get_bus_index(bus_name)


func _ready():
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_id))
	value_changed.connect(_on_value_changed)


func _on_value_changed(val):
	AudioServer.set_bus_volume_db(bus_id, linear_to_db(val))
