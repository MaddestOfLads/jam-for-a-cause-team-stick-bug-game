class_name Bridge extends Line2D


var _island_1: Island = null
var _island_2: Island = null


func build(island_1_: Island, island_2_: Island) -> Bridge:
	self._island_1 = island_1_
	self._island_2 = island_2_

	self.add_point(_island_1.position)
	self.add_point(_island_2.position)

	return self
