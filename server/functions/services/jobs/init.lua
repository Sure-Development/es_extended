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

---@return nil
function ESX.RefreshJobs()
  Core.JobsLoaded = false

  local Jobs = {}
  local jobs = MySQL.query.await('SELECT * FROM jobs')

  for _, v in ipairs(jobs) do
    Jobs[v.name] = v
    Jobs[v.name].grades = {}
    Core.IdsByJobs[v.name] = {}
  end

  local jobGrades = MySQL.query.await('SELECT * FROM job_grades')

  for _, v in ipairs(jobGrades) do
    if Jobs[v.job_name] then
      Jobs[v.job_name].grades[tostring(v.grade)] = v
    else
      lib.print.warn(('[^3WARNING^7] Ignoring job grades for ^5 %s ^0 due to missing job'):format(v.job_name))
    end
  end

  for _, v in pairs(Jobs) do
    if ESX.Table.SizeOf(v.grades) == 0 then
      Jobs[v.name] = nil
      lib.print.warn(('[^3WARNING^7] Ignoring job ^5 %s ^0 due to no job grades found'):format(v.name))
    end
  end

  if not Jobs then
    ESX.Jobs['unemployed'] = {
      name = 'unemployed',
      label = 'Unemployed',
      grades = { ['0'] = { grade = 0, name = 'unemployed', label = 'Unemployed', salary = 200, skin_male = {}, skin_female = {} } },
    }
  else
    ESX.Jobs = Jobs
  end

  TriggerEvent('esx:jobsRefreshed')
  Core.JobsLoaded = true
end

---@return table
function ESX.GetJobs()
  while not Core.JobsLoaded do
    Citizen.Wait(200)
  end

  return ESX.Jobs
end

---@param job string
---@param grade integer | string
---@return boolean
function ESX.DoesJobExist(job, grade)
  while not Core.JobsLoaded do
    Citizen.Wait(200)
  end

  return (ESX.Jobs[job] and ESX.Jobs[job].grades[tostring(grade)] ~= nil) or false
end
