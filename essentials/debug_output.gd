extends Node


@export var button: Button
@export var label: RichTextLabel
@export var panel: PanelContainer


func _close_line():
	label.pop_context()


func _on_toggled(toggled_on: bool):
	if toggled_on:
		panel.show()
	else:
		panel.hide()


func _open_line():
	label.push_context()
	label.push_paragraph(HORIZONTAL_ALIGNMENT_LEFT)


func _ready():
	#var p = get_parent()
	#p.remove_child.call_deferred(self)
	#p.add_child.call_deferred(self, true, Node.INTERNAL_MODE_FRONT)
	button.toggled.connect(_on_toggled)
	_on_toggled(false)
	w("Normal")
	w_e("Error")
	w_w("Warning")


func w(wr):
	_open_line()
	label.add_text(str(wr))
	_close_line()


func w_e(e):
	_open_line()
	label.push_color(Color.RED)
	label.add_text(str(e))
	_close_line()


func w_w(wa):
	_open_line()
	label.push_color(Color.YELLOW)
	label.add_text(str(wa))
	_close_line()
