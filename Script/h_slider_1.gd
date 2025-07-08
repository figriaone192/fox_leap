extends HSlider

@export var bus_name: String
var bus_index: int

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

func linear_to_db(value: float) -> float:
	if value <= 0.0:
		return -80.0  # Volume minimum (dibisukan)
	return 20.0 * log(value) / log(10.0)

func db_to_linear(db: float) -> float:
	return pow(10.0, db / 20.0)
