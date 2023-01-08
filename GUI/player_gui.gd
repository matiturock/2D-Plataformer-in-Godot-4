extends CanvasLayer

var fruits_number: int = 0:
	set(value):
		fruits_number += value
		$VBoxContainerFruits/LabelFruit.text = str(fruits_number)
	get:
		return fruits_number

var life_number: int = 1:
	set(value):
		life_number = value
		$VBoxContainerLife/LabelNumber.text = str(life_number)
	get:
		return life_number
