ESX = exports['es_extended']:getSharedObject()

if not IsDuplicityVersion() then
  AddEventHandler('esx:setPlayerData', function(key, val)
    if GetInvokingResource() == 'es_extended' then
      ESX.PlayerData[key] = val
    end
  end)
else
  local mapKeyMethods = {
    job = 'getJob',
    source = 'getSource',
    playerId = 'getSource',
    group = 'getGroup',
    identifier = 'getIdentifier',
    license = 'getIdentifier',
    metadata = 'getMetadata',
    accounts = 'getAccounts',
    inventory = 'getInventory',
    loadout = 'getLoadout',
    admin = 'isAdmin',
    name = 'getName',
    coords = 'getCoords',
  }

  ---@class (functions) DEX.Player.Functions : DEX.Player
  ---@param src number
  ---@return DEX.Player.Functions
  local function createStaticPlayer(src)
    return setmetatable({ src = src }, {
      __index = function(self, key)
        if mapKeyMethods[key] then
          local methodName = mapKeyMethods[key]
          return exports.es_extended:runStaticPlayerMethod(self.src, methodName)
        end

        return function(...)
          return exports.es_extended:runStaticPlayerMethod(self.src, key, ...)
        end
      end,
    })
  end

  ---@param src number|string
  ---@return DEX.Player.Functions?
  function ESX.Player(src)
    if type(src) ~= 'number' then
      src = ESX.GetPlayerIdFromIdentifier(src)
      if not src then
        return
      end
    elseif not ESX.IsPlayerLoaded(src) then
      return
    end

    return createStaticPlayer(src)
  end

  ---@param key? string
  ---@param val? string|string[]
  ---@return DEX.Player.Functions[] | table<any, DEX.Player.Functions[]>
  function ESX.ExtendedPlayers(key, val)
    local playerIds = ESX.GetExtendedPlayers(key, val, true)

    if key and type(val) == 'table' then
      ---@cast playerIds table<any, number[]>
      local retVal = {}
      for group, ids in pairs(playerIds) do
        retVal[group] = {}
        for i = 1, #ids do
          retVal[group][i] = createStaticPlayer(ids[i])
        end
      end
      return retVal
    else
      ---@cast playerIds number[]
      local retVal = {}
      for i = 1, #playerIds do
        retVal[i] = createStaticPlayer(playerIds[i])
      end
      return retVal
    end
  end
end
