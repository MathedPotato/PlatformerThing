extends StaticBody


func TakeDamage(other : DmgObj):
	if other.type == DmgObj.DamageType.GPOUND:
		if !$"..".pressed:
			$"..".Press(other)
			return
		elif $"..".pressed and $"..".toggleable:
			$"..".Unpress(other)
			return
