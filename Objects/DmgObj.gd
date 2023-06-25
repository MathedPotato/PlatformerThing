extends Node

class_name DmgObj
# This class holds info about a damage instance

enum DamageType {GPOUND, PROJECTILE, STANDMELEE, ROLL, AIR}

var type
var power : float
var origin : Vector3
var parentObject : Node
