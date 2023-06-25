extends Node

class_name MinecartGame


export(NodePath) onready var minecart = get_node(minecart) as DriveableObj
export(NodePath) var track
export var altitudeSpeedFactor := 0.0
export var baseAltitude := 0.0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var minecartY = (minecart as Spatial).global_transform.origin.y
#	print(minecartY)
#	print(baseAltitude)
#	print(minecart.speedFactor)
	if minecartY <= baseAltitude:
		minecart.speedFactor = (baseAltitude - minecartY) * altitudeSpeedFactor + 1.0
	else:
		minecart.speedFactor = 1/((minecartY - baseAltitude) * altitudeSpeedFactor + 1.0)
	
	var minecartCollidedObjs = (minecart as Area).get_overlapping_areas()
	
	for obj in minecartCollidedObjs:
		if obj is MinecartTrackModifier:
			minecart.speedFactor *= obj.speedModifier
