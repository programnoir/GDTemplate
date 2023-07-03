extends CanvasLayer

signal fade_complete

@onready var nColorRect: ColorRect = get_node( "ColorRect" )

enum { IDLE, BLACK, OUT, IN }

var state: int = IDLE : set = set_state
var percent: float = 0 : set = set_percent


func _on_tween_finished() -> void:
	match state:
		IN:
			state = IDLE
		OUT:
			state = BLACK
	visible = false
	emit_signal( "fade_complete" )


func set_percent( value: float ) -> void:
	percent = clamp( value, 0.0, 1.0 )
	nColorRect.modulate.a = percent


func set_state( value: int )->void:
	state = value
	var tween = get_tree().create_tween()
	match state:
		OUT:
			#	Fading to black
			tween.tween_property( self, "percent", 0.0, 0.5 )
			tween.play()
		IN:
			#	Fading from black
			tween.tween_property( self, "percent", 1.0, 0.5 )
			tween.play()
	visible = true
	await tween.finished
	tween.kill()
	self._on_tween_finished()


func _ready() -> void:
	nColorRect.modulate.a = percent


func _exit_tree() -> void:
	destroy()


func destroy() -> void:
	pass
