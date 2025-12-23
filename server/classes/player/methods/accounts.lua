--[[
    _________________________________________
   |    __      _                            |
   |  o'')}____//      D O G E A T E R X     |
   |   `_/      )      Development           |
   |   (_(_/-(_/                             |
   |_________________________________________|

  Discord : https://discord.gg/Pnsta3xnZX

  ⚠  OUR CODE | THANKS FOR YOUR TRUSTED
--]]

---@param minimal boolean?
---@return DEX.Account[] | table<string, integer>
---@overload fun(minimal?: boolean): DEX.Account[] | table<string, integer>
function ExtendedPlayer:getAccounts(minimal)
  if not minimal then
    return self.accounts
  end

  local minimalAccounts = {}

  for name, acount in pairs(self.accounts) do
    minimalAccounts[name] = acount.money
  end

  return minimalAccounts
end

---@param account string
---@return DEX.Account?
---@overload fun(account: string): DEX.Account?
function ExtendedPlayer:getAccount(account)
  account = string.lower(account)

  if self.accounts[account] then
    return self.accounts[account]
  end

  return nil
end

---@param name string
---@param money number
---@overload fun(name: string, money: integer)
function ExtendedPlayer:setAccountMoney(name, money)
  if not tonumber(money) then
    error(('Tried To Set Account ^5%s^1 For Player ^5%s^1 To An Invalid Number -> ^5%s^1'):format(name, self.playerId, money))
    return
  end
  if money >= 0 then
    local account = self:getAccount(name)

    if account then
      money = account.round and lib.math.round(money) or money
      self.accounts[name].money = money

      self:triggerEvent('esx:setAccountMoney', account)
      TriggerEvent('esx:setAccountMoney', self.source, name, money)
    else
      error(('Tried To Set Invalid Account ^5%s^1 For Player ^5%s^1!'):format(name, self.playerId))
    end
  else
    error(('Tried To Set Account ^5%s^1 For Player ^5%s^1 To An Invalid Number -> ^5%s^1'):format(name, self.playerId, money))
  end
end

---@param name string
---@param money number
---@overload fun(name: string, money: integer)
function ExtendedPlayer:addAccountMoney(name, money)
  if not tonumber(money) then
    error(('Tried To Set Account ^5%s^1 For Player ^5%s^1 To An Invalid Number -> ^5%s^1'):format(name, self.playerId, money))
    return
  end
  if money > 0 then
    local account = self:getAccount(name)
    if account then
      money = account.round and lib.math.round(money) or money
      self.accounts[name].money = self.accounts[name].money + money

      self:triggerEvent('esx:setAccountMoney', account)
      TriggerEvent('esx:addAccountMoney', self.source, name, money)
    else
      error(('Tried To Set Add To Invalid Account ^5%s^1 For Player ^5%s^1!'):format(name, self.playerId))
    end
  else
    error(('Tried To Set Account ^5%s^1 For Player ^5%s^1 To An Invalid Number -> ^5%s^1'):format(name, self.playerId, money))
  end
end

---@param name string
---@param money number
---@overload fun(name: string, money: integer)
function ExtendedPlayer:removeAccountMoney(name, money)
  if not tonumber(money) then
    error(('Tried To Set Account ^5%s^1 For Player ^5%s^1 To An Invalid Number -> ^5%s^1'):format(name, self.playerId, money))
    return
  end
  if money > 0 then
    local account = self:getAccount(name)

    if account then
      money = account.round and lib.math.round(money) or money
      if self.accounts[name].money - money > self.accounts[name].money then
        error(('Tried To Underflow Account ^5%s^1 For Player ^5%s^1!'):format(name, self.playerId))
        return
      end
      self.accounts[name].money = self.accounts[name].money - money

      self:triggerEvent('esx:setAccountMoney', account)
      TriggerEvent('esx:removeAccountMoney', self.source, name, money)
    else
      error(('Tried To Set Add To Invalid Account ^5%s^1 For Player ^5%s^1!'):format(name, self.playerId))
    end
  else
    error(('Tried To Set Account ^5%s^1 For Player ^5%s^1 To An Invalid Number -> ^5%s^1'):format(name, self.playerId, money))
  end
end

---@return integer
---@overload fun(): integer
function ExtendedPlayer:getMoney()
  return self:getAccount('money').money
end

---@param money number
---@overload fun(money: integer)
function ExtendedPlayer:setMoney(money)
  assert(type(money) == 'number', 'money should be number!')
  money = math.round(money)
  self:setAccountMoney('money', money)
end

---@param money number
---@overload fun(money: integer)
function ExtendedPlayer:addMoney(money)
  money = math.round(money)
  self:addAccountMoney('money', money)
end

---@param money number
---@overload fun(money: integer)
function ExtendedPlayer:removeMoney(money)
  money = math.round(money)
  self:removeAccountMoney('money', money)
end
