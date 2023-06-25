extends Spatial

class_name ClimbableObj


var yScaleFactor := 2
var radius := 4

func NextPos(currPos: Vector3, input: Vector3, delta: float, playerTop: float = 3) -> Vector3:
	var newPos := currPos
	var localPos: Vector3
	#print("Bottom:",GetObjBottomGlobal())
	#print("Top:",GetObjTopGlobal())
	#print("Top local:",GetObjTopLocal())
	#print(currPos)
	localPos = global_transform.affine_inverse().xform(currPos)
	#print(localPos)
	var hDisp := Vector3(localPos.x, 0, localPos.z)
	var angle = atan2(hDisp.z, hDisp.x)
	hDisp = Vector3(hDisp.normalized().x, localPos.y, hDisp.normalized().z)
	#print(hDisp)
	#hDisp.x = cos(hDisp.z + input.x/10) * radius
	#hDisp.z = sin(hDisp.x + input.x/10) * radius
	#print(angle)
#	angle += input.x
#	hDisp.x = cos(angle) * radius
#	hDisp.z = sin(angle) * radius
	hDisp = hDisp.rotated(Vector3(0,1,0), input.x)# * (radius - localPos.distance_to(Vector3(0, localPos.y, 0)))
	hDisp.x *= (radius - localPos.distance_to(Vector3(0, localPos.y, 0))) / delta
	hDisp.z *= (radius - localPos.distance_to(Vector3(0, localPos.y, 0))) / delta
	#hDisp.y /= radius
	hDisp = global_transform.xform(hDisp)
	hDisp = hDisp - currPos
	#print(hDisp)
	newPos += input.y * global_transform.basis.y.normalized()
	#print("New pos:", global_transform.affine_inverse().xform(currPos))
	#print(playerTop / scale.y)
	if (global_transform.affine_inverse().xform(currPos) + ((global_transform.affine_inverse().xform(newPos) - global_transform.affine_inverse().xform(currPos)) * delta)).y < GetObjBottomLocal().y:
		print("below obj")
	if ((global_transform.affine_inverse().xform(currPos) + ((global_transform.affine_inverse().xform(newPos) - global_transform.affine_inverse().xform(currPos)) * delta))).y + (playerTop / scale.y) > GetObjTopLocal().y:
		print("above obj")
		newPos = currPos#transform.xform(Vector3(GetObjTopLocal().x, GetObjTopLocal().y - playerTop, GetObjTopLocal().z))
	#print(input.y)
	
	#newPos.y = clamp(newPos.y, GetObjBottom().y, GetObjTop().y)
	newPos += hDisp
	return newPos

func GetObjBottomLocal() -> Vector3:
	#print("Obj bottom: ", transform.origin.y * transform.basis.y)
	return transform.origin

func GetObjTopLocal() -> Vector3:
	#var vecTop = transform.origin
	#vecTop.y += scale.y * 2
	#print("Obj top: ", vecTop.y * get_global_transform().basis.y)
	return transform.basis.y.normalized() * yScaleFactor - transform.origin

func GetObjBottomGlobal() -> Vector3:
	#print("Obj bottom: ", transform.origin.y * transform.basis.y)
	return global_transform.origin

func GetObjTopGlobal() -> Vector3:
	#var vecTop = transform.origin
	#vecTop.y += scale.y * 2
	#print("Obj top: ", vecTop.y * get_global_transform().basis.y)
	return global_transform.xform(GetObjTopLocal())# + GetObjBottomGlobal()
