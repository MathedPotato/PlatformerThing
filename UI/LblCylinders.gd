extends Label


onready var baseText : String = self.text
var numCylinders := 0
export var displayTime := 5
export var transitionTime := 1.0

func _ready():
	GameEvents.connect("GreatCylinderGet", self, "CylinderCollected")
	UpdateCylinderCount(GameManager.playerData.greatCylinders.size())
	UpdateText(numCylinders)
#	CylinderCollected(GreatCylinder.new(), 10)

func CylinderCollected(cylinder: GreatCylinder, newNumCylinders: int):
	yield(ShowDisplay(), "completed")
	UpdateCylinderCount(newNumCylinders)
	UpdateText(numCylinders)
	yield(get_tree().create_timer(displayTime), "timeout")
	yield(HideDisplay(), "completed")

func ShowDisplay():
	var tweenObj : Tween = get_node("Tween") as Tween
	tweenObj.interpolate_property($"../../..", "rect_position", Vector2(0,-32), Vector2(0,0), transitionTime, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tweenObj.start()
	
	yield(tweenObj, "tween_completed")

func HideDisplay():
	var tweenObj : Tween = get_node("Tween") as Tween
	tweenObj.interpolate_property($"../../..", "rect_position", Vector2(0,0), Vector2(0,-32), transitionTime, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tweenObj.start()
	
	yield(tweenObj, "tween_completed")

func UpdateCylinderCount(newNumCylinders: int):
	numCylinders = newNumCylinders

func UpdateText(count: int):
	text = baseText + String(numCylinders)
