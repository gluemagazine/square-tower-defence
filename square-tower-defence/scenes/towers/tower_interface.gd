extends CanvasLayer
class_name TowerInteface

func build():
	pass

func open():
	show()

func close():
	hide()

func select():
	Game.tower_opened.emit(self)

func check(tower):
	if tower == self:
		open()
	else:
		close()
