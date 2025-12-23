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

---@alias Server.classes.orm.result any | { [number]: { [string]: unknown } }
---@class Server.classes.orm
local ORM = {}

---Executes a raw SQL query and returns multiple rows.
---@param sql string The SQL query string.
---@param params? table|any Parameters to bind to the query.
---@return Server.classes.orm.result
function ORM:rawQuery(sql, params)
  return MySQL.query.await(sql, params)
end

---Executes a raw SQL query and returns only the first row.
---@param sql string The SQL query string.
---@param params? table|any Parameters to bind to the query.
---@return table|nil
function ORM:rawSingle(sql, params)
  return MySQL.single.await(sql, params)
end

---Executes a raw SQL query and returns the first column of the first row.
---@param sql string The SQL query string.
---@param params? table|any Parameters to bind to the query.
---@return any
function ORM:rawScalar(sql, params)
  return MySQL.scalar.await(sql, params)
end

---Executes an INSERT query and returns the ID of the inserted row.
---@param sql string The SQL query string.
---@param params? table|any Parameters to bind to the query.
---@return number insertId
function ORM:rawInsert(sql, params)
  return MySQL.insert.await(sql, params)
end

---Executes an UPDATE or DELETE query and returns the number of affected rows.
---@param sql string The SQL query string.
---@param params? table|any Parameters to bind to the query.
---@return number affectedRows
function ORM:rawExecute(sql, params)
  return MySQL.update.await(sql, params)
end

---Prepares and executes a query, often used for performance in repeated tasks.
---@param sql string The SQL query string.
---@param params? table|any Parameters to bind to the query.
---@return any
function ORM:prepare(sql, params)
  return MySQL.prepare.await(sql, params)
end

---Executes multiple queries within a single database transaction.
---@param queries table A list of queries (strings or tables with query/values).
---@return boolean success
function ORM:transaction(queries)
  return MySQL.transaction.await(queries)
end

---Helper to build a WHERE clause string and parameter array from a table.
---@param where table Key-value pairs for the WHERE clause.
---@return string clause The formatted "WHERE ..." string.
---@return table vals The ordered values for binding.
local function buildWhereClause(where)
  local keys, vals = {}, {}
  for k, v in pairs(where) do
    keys[#keys + 1] = ('`%s`'):format(k) .. ' = ?'
    vals[#vals + 1] = v
  end

  if #keys > 0 then
    return 'WHERE ' .. table.concat(keys, ' AND '), vals
  end

  return '', vals
end

---Finds multiple records in a table based on conditions.
---@param tableName string The name of the database table.
---@param where? table Key-value pairs for the filter.
---@return Server.classes.orm.result
function ORM:find(tableName, where)
  local clause, vals = buildWhereClause(where or {})
  local sql = ('SELECT * FROM %s %s'):format(tableName, clause)
  return ORM:rawQuery(sql, vals)
end

---Finds multiple records in a table based on conditions.
---@param tableName string The name of the database table.
---@param where? table Key-value pairs for the filter.
---@return Server.classes.orm.result
function ORM:findPrepare(tableName, where)
  local clause, vals = buildWhereClause(where or {})
  local sql = ('SELECT * FROM %s %s'):format(tableName, clause)
  return ORM:prepare(sql, vals)
end

---Finds a single record in a table based on conditions.
---@param tableName string The name of the database table.
---@param where? table Key-value pairs for the filter.
---@return table|nil
function ORM:findOne(tableName, where)
  local rows = ORM:find(tableName, where)
  return rows and rows[1] or nil
end

---Inserts a new record into a table. Automatically JSON encodes table values.
---@param tableName string The name of the database table.
---@param data table Key-value pairs of data to insert.
---@return number insertId
function ORM:createPrepare(tableName, data)
  local cols, placeholders, vals = {}, {}, {}

  for k, v in pairs(data) do
    cols[#cols + 1] = ('`%s`'):format(k)
    placeholders[#placeholders + 1] = '?'

    if type(v) == 'table' then
      vals[#vals + 1] = json.encode(v)
    else
      vals[#vals + 1] = v
    end
  end

  local sql = ('INSERT INTO %s (%s) VALUES (%s)'):format(tableName, table.concat(cols, ','), table.concat(placeholders, ','))

  return ORM:prepare(sql, vals)
end

---Inserts a new record into a table. Automatically JSON encodes table values.
---@param tableName string The name of the database table.
---@param data table Key-value pairs of data to insert.
---@return number insertId
function ORM:create(tableName, data)
  local cols, placeholders, vals = {}, {}, {}

  for k, v in pairs(data) do
    cols[#cols + 1] = ('`%s`'):format(k)
    placeholders[#placeholders + 1] = '?'

    if type(v) == 'table' then
      vals[#vals + 1] = json.encode(v)
    else
      vals[#vals + 1] = v
    end
  end

  local sql = ('INSERT INTO %s (%s) VALUES (%s)'):format(tableName, table.concat(cols, ','), table.concat(placeholders, ','))

  return ORM:rawInsert(sql, vals)
end

---Updates existing records based on a WHERE clause. Automatically JSON encodes table values.
---@param tableName string The name of the database table.
---@param data table Key-value pairs of columns to update.
---@param where table Key-value pairs for the filter.
---@return number affectedRows
function ORM:updateWhere(tableName, data, where)
  local updates, vals = {}, {}

  for k, v in pairs(data) do
    updates[#updates + 1] = ('`%s`'):format(k) .. ' = ?'

    if type(v) == 'table' then
      vals[#vals + 1] = json.encode(v)
    else
      vals[#vals + 1] = v
    end
  end

  local clause, whereVals = buildWhereClause(where)
  for _, v in ipairs(whereVals) do
    vals[#vals + 1] = v
  end

  local sql = ('UPDATE %s SET %s %s'):format(tableName, table.concat(updates, ','), clause)

  return ORM:rawExecute(sql, vals)
end

---Deletes records from a table based on conditions.
---@param tableName string The name of the database table.
---@param where table Key-value pairs for the filter.
---@return number affectedRows
function ORM:delete(tableName, where)
  local clause, vals = buildWhereClause(where)
  local sql = ('DELETE FROM %s %s'):format(tableName, clause)
  return ORM:rawExecute(sql, vals)
end

---Creates a table if it doesn't exist.
---@param tableName string The name of the table to create.
---@param columns table A table defining columns, e.g., { { name = "id", type = "INT PRIMARY KEY AUTO_INCREMENT" }, { name = "username", type = "VARCHAR(255)" } }
---@return boolean success
function ORM:createTableIfNotExists(tableName, columns)
  local columnDefs = {}
  for _, col in ipairs(columns) do
    if col.name and col.type then
      columnDefs[#columnDefs + 1] = ('`%s` %s'):format(col.name, col.type)
    end
  end

  if #columnDefs == 0 then
    return false
  end

  local sql = ('CREATE TABLE IF NOT EXISTS %s (%s)'):format(tableName, table.concat(columnDefs, ', '))

  local success, err = pcall(function()
    return MySQL.query.await(sql)
  end)

  if not success then
    return false
  end

  return true and (err.warningStatus or 0) == 0
end

---Drops/removes a table from the database.
---@param tableName string The name of the table to drop.
---@param ifExists? boolean Optional flag to use IF EXISTS clause (default: true).
---@return boolean success
function ORM:dropTable(tableName, ifExists)
  if ifExists == nil then
    ifExists = true
  end

  local sql = ifExists and ('DROP TABLE IF EXISTS %s'):format(tableName) or ('DROP TABLE %s'):format(tableName)

  local success, err = pcall(function()
    return MySQL.query.await(sql)
  end)

  if not success then
    return false
  end

  return true
end

---Truncates a table (removes all rows but keeps the structure).
---@param tableName string The name of the table to truncate.
---@return boolean success
function ORM:truncateTable(tableName)
  local sql = ('TRUNCATE TABLE %s'):format(tableName)

  local success, err = pcall(function()
    return MySQL.query.await(sql)
  end)

  if not success then
    return false
  end

  return true
end

return ORM
