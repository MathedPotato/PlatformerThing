tool
extends Path

class_name MinecartTrack


var trackVisualObjPrefab := preload("res://Objects/MinecartTrack.tscn")
export var trackFreq := 10.0 setget ChangeTrackFreq
export var updateWholeTrack := false setget ChangeUpdateWholeTrack
var trackPointMirror := PoolVector3Array()
export var skipFirst : bool
#export(NodePath) var trackVisualParent

func _ready() -> void:
	#pass
	if Engine.editor_hint:
		trackPointMirror = curve.tessellate(0,1111)
#	if !Engine.editor_hint:
#		RecalcVisuals()
#		print(curve.tessellate())
#		trackPointMirror = curve.tessellate(0,1111)

func ChangeTrackFreq(newFreq):
	trackFreq = newFreq
	RecalcVisuals()

func ChangeUpdateWholeTrack(newValue):
	updateWholeTrack = newValue
	if newValue:
		RecalcVisuals()

func RecalcVisuals():
	if !Engine.editor_hint:
		return
	var newTrackPointMirror := curve.tessellate(0,1111)
	var changedPointIndex := -1
	var minOffset := 0.0
	var maxOffset := curve.get_baked_length()
	for index in range(0, min(trackPointMirror.size(), newTrackPointMirror.size())):
		if trackPointMirror[index] != newTrackPointMirror[index]:
			changedPointIndex = index
			if changedPointIndex > 0:
				minOffset = curve.get_closest_offset(trackPointMirror[changedPointIndex-1])
			if changedPointIndex < min(trackPointMirror.size(), newTrackPointMirror.size())-1:
				maxOffset = curve.get_closest_offset(trackPointMirror[changedPointIndex+1])
			break
	
	for track in get_children():
		if (track.name as String).begins_with("TrackPathFollow"):
			if updateWholeTrack:
				track.queue_free()
				remove_child(track)
			else:
				if track.offset >= minOffset and track.offset <= maxOffset:
					track.queue_free()
					remove_child(track)
	
	var trackOffset : float = 0.0
	#for i in range(0, floor(curve.get_baked_length()), trackFreq):
	if updateWholeTrack:
		while trackOffset < curve.get_baked_length():
			if skipFirst and trackOffset < trackFreq:
				trackOffset += trackFreq
				continue
			var newTrackObj := trackVisualObjPrefab.instance()
	#		newTrackObj.global_transform.origin = curve.interpolate_baked(i)
	#		newTrackObj
			var newPathFollow := PathFollow.new()
			newPathFollow.name = "TrackPathFollow"
			newPathFollow.offset = trackOffset
			newPathFollow.rotation_mode = PathFollow.ROTATION_ORIENTED
			newPathFollow.add_child(newTrackObj)
			add_child(newPathFollow)
			newPathFollow.set_owner(get_tree().edited_scene_root)
			newTrackObj.set_owner(get_tree().edited_scene_root)
			trackOffset += trackFreq
	else:
		trackOffset = minOffset
		while trackOffset < maxOffset:
			if skipFirst and trackOffset < trackFreq:
				trackOffset += trackFreq
				continue
			var newTrackObj := trackVisualObjPrefab.instance()
	#		newTrackObj.global_transform.origin = curve.interpolate_baked(i)
	#		newTrackObj
			var newPathFollow := PathFollow.new()
			newPathFollow.name = "TrackPathFollow"
			newPathFollow.offset = trackOffset
			newPathFollow.rotation_mode = PathFollow.ROTATION_ORIENTED
			newPathFollow.add_child(newTrackObj)
			add_child(newPathFollow)
			newPathFollow.set_owner(get_tree().edited_scene_root)
			newTrackObj.set_owner(get_tree().edited_scene_root)
			trackOffset += trackFreq
	trackPointMirror = newTrackPointMirror


func _on_Path_curve_changed() -> void:
	RecalcVisuals()
