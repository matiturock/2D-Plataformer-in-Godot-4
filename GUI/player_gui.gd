extends CanvasLayer

var fruits_number: int = 0:
	set(value):
		fruits_number += value
		$VBoxContainerFruits/LabelFruit.text = str(fruits_number)
	get:
		return fruits_number

var life_value: int:
	set(value):
		life_value = value
		$Sprite2DBarLife/ProgressBarLife.value = value
	get:
		return life_value

var max_life_value: int:
	set(value):
		$Sprite2DBarLife/ProgressBarLife.max_value = value
	get:
		return max_life_value
