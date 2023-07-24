--########################## CLOTHING STORE ##########################
RegisterNetEvent('xakra_clothingstores:OpenClothingStore')
AddEventHandler('xakra_clothingstores:OpenClothingStore', function()
	local _source = source
	local Character = VORPcore.getUser(_source).getUsedCharacter

	exports.oxmysql:execute("SELECT * FROM outfits WHERE identifier = @identifier AND charidentifier = @charidentifier", { ['@identifier'] = Character.identifier, ['@charidentifier'] = Character.charIdentifier }, function(Outfits)
		TriggerClientEvent('xakra_clothingstores:OpenClothingStore', _source, json.decode(Character.comps), json.decode(Character.skin), Outfits)
	end)
end)

--########################## BUY CLOTHING STORE ##########################
RegisterNetEvent('xakra_clothingstores:BuyClothes')
AddEventHandler('xakra_clothingstores:BuyClothes', function(Price, Comps, OutfitName)
	local _source = source
	local Character = VORPcore.getUser(_source).getUsedCharacter

	if Character.money < Price then
        VORPcore.NotifyObjective(_source, _U('NotMoney'), 4000)
        return
    end

	if Price > 0 then
		Character.removeCurrency(0, Price)
	end

	-- Character.updateComps(json.encode(Comps))
	TriggerClientEvent("vorpcharacter:updateCache", _source, false, Comps)
	TriggerClientEvent("xakra_clothingstores:CloseClothingStore", _source)

	if OutfitName ~= nil and OutfitName ~= "" then
		local Parameters = { ['@identifier'] = Character.identifier, ['@charidentifier'] = Character.charIdentifier, ['@Name'] = OutfitName, ['@Comps'] = json.encode(Comps) }
		exports.ghmattimysql:execute("INSERT INTO outfits (identifier, charidentifier, title, comps) VALUES (@identifier, @charidentifier, @Name, @Comps)", Parameters)
	end
end)

--########################## BUY MAKEUP STORE ##########################
RegisterNetEvent('xakra_clothingstores:BuyMakeup')
AddEventHandler('xakra_clothingstores:BuyMakeup', function(Price, Skin)
	local _source = source
	local Character = VORPcore.getUser(_source).getUsedCharacter

	if Character.money < Price then
        VORPcore.NotifyObjective(_source, _U('NotMoney'), 4000)
        return
    end

	if Price > 0 then
		Character.removeCurrency(0, Price)
	end

	-- Character.updateSkin(json.encode(Skin))
	TriggerClientEvent("vorpcharacter:updateCache", _source, Skin, false)
	TriggerClientEvent("xakra_clothingstores:CloseClothingStore", _source)
end)

--########################## OUTFITS ##########################
RegisterNetEvent('xakra_clothingstores:SetOutfit')
AddEventHandler('xakra_clothingstores:SetOutfit', function(Comps)
	local _source = source
	TriggerClientEvent("vorpcharacter:updateCache", _source, false, Comps)
end)

RegisterNetEvent('xakra_clothingstores:DeleteOutfit')
AddEventHandler('xakra_clothingstores:DeleteOutfit', function(id)
	exports.oxmysql:execute("DELETE FROM outfits WHERE id = @id", { ['@id'] = id })
end)


