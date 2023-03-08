extends Node

func map_range (number, inMin, inMax, outMin, outMax):
	return (number - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
