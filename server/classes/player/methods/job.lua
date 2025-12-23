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

---@return DEX.PlayerJob
---@overload fun(): DEX.PlayerJob
function ExtendedPlayer:getJob()
  return self.job
end

---@param newJob string
---@param grade integer
---@overload fun(newJob: string, grade: integer)
function ExtendedPlayer:setJob(newJob, grade)
  local lastJob = self.job

  if not ESX.DoesJobExist(newJob, grade) then
    return lib.print.warn(('[ESX] [^3WARNING^7] Ignoring invalid ^5.setJob()^7 usage for ID: ^5%s^7, Job: ^5%s^7'):format(self.source, newJob))
  end

  local jobObject, gradeObject = ESX.Jobs[newJob], ESX.Jobs[newJob].grades[grade]

  self.job = {
    id = jobObject.id,
    name = jobObject.name,
    label = jobObject.label,

    grade = tonumber(grade) or 0,
    grade_name = gradeObject.name,
    grade_label = gradeObject.label,
    grade_salary = gradeObject.salary,

    skin_male = gradeObject.skin_male and json.decode(gradeObject.skin_male) or {},
    skin_female = gradeObject.skin_female and json.decode(gradeObject.skin_female) or {},
  }

  TriggerEvent('esx:setJob', self.source, self.job, lastJob)

  self:triggerEvent('esx:setJob', self.job, lastJob)
  Player(self.source).state:set('job', self.job, true)
end
