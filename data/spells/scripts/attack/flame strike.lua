local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_FIREAREA)
setCombatFormula(combat, COMBAT_FORMULA_LEVELMAGIC, -0.3, -0, -0.5, 0)

function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
