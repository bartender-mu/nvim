-- ================================================================================================
-- TITLE : Opencode AI Core Module
-- ABOUT : Core functionality for Opencode AI integration in Neovim
-- AUTHOR : Opencode AI Assistant
-- ================================================================================================

local M = {}

-- HTTP client for API communication
local function http_request(url, method, headers, body, callback)
  local curl_cmd = {
    "curl",
    "-s",  -- silent
    "-X", method,
    "-H", "Content-Type: application/json",
  }
  
  -- Add headers
  for key, value in pairs(headers or {}) do
    table.insert(curl_cmd, "-H")
    table.insert(curl_cmd, key .. ": " .. value)
  end
  
  -- Add body if provided
  if body then
    local json_body = vim.json.encode(body)
    table.insert(curl_cmd, "-d")
    table.insert(curl_cmd, json_body)
  end
  
  -- Add URL
  table.insert(curl_cmd, url)
  
  vim.fn.jobstart(curl_cmd, {
    on_exit = function(job_id, exit_code, signal)
      if exit_code == 0 then
        callback(true, job_id)
      else
        callback(false, job_id)
      end
    end,
    on_stdout = function(job_id, data)
      callback(true, job_id, data)
    end,
    on_stderr = function(job_id, data)
      callback(false, job_id, data)
    end,
  })
end

-- Parse API response
local function parse_response(response_data)
  local success, data = pcall(vim.json.decode, response_data)
  if success and data then
    return true, data.response or data
  end
  return false, response_data
end

-- Get API key from environment or config
local function get_api_key()
  return os.getenv("OPENCODE_API_KEY") or vim.g.opencode_api_key
end

-- Get API endpoint
local function get_api_endpoint()
  return "https://api.opencode.ai/v1" -- Replace with actual endpoint
end

-- Initialize Opencode AI
function M.setup(config)
  local api_key = get_api_key()
  if not api_key then
    vim.notify("Opencode AI: API key not found. Set OPENCODE_API_KEY environment variable or vim.g.opencode_api_key", vim.log.levels.ERROR)
    return false
  end
  
  M.config = vim.tbl_extend("force", {
    api_key = api_key,
    api_endpoint = get_api_endpoint(),
    model = "big-pickle",
    context = config.context or "general",
    integrations = config.integrations or {},
    neovim = config.neovim or {},
  }, config)
  
  -- Store for module use
  vim.g.opencode_config = M.config
  
  return true
end

-- Main API functions
function M.ask(question, callback)
  if not M.config then
    vim.notify("Opencode AI: Not initialized. Call setup() first.", vim.log.levels.ERROR)
    return nil
  end
  
  local request_body = {
    question = question,
    context = M.config.context,
    model = M.config.model,
  }
  
  http_request(M.config.api_endpoint .. "/ask", "POST", {
    ["Authorization"] = "Bearer " .. M.config.api_key,
  }, request_body, function(success, job_id, response_data)
    if success then
      local parse_success, data = parse_response(response_data)
      if parse_success and data.answer then
        if callback then
          callback(data.answer)
        else
          return data.answer
        end
      else
        local error_msg = parse_success and data.error or "Invalid response"
        vim.notify("Opencode AI: " .. error_msg, vim.log.levels.ERROR)
        if callback then callback(nil) end
      end
    else
      vim.notify("Opencode AI: Request failed", vim.log.levels.ERROR)
      if callback then callback(nil) end
    end
  end)
end

function M.analyze_code(code, options, callback)
  if not M.config then
    vim.notify("Opencode AI: Not initialized. Call setup() first.", vim.log.levels.ERROR)
    return nil
  end
  
  local request_body = {
    code = code,
    context = options.context or M.config.context,
    language = options.language,
    filetype = options.filetype,
    analysis_type = options.analysis_type or "general",
  }
  
  http_request(M.config.api_endpoint .. "/analyze", "POST", {
    ["Authorization"] = "Bearer " .. M.config.api_key,
  }, request_body, function(success, job_id, response_data)
    if success then
      local parse_success, data = parse_response(response_data)
      if parse_success and data.analysis then
        if callback then
          callback(data.analysis)
        else
          return data.analysis
        end
      else
        local error_msg = parse_success and data.error or "Invalid response"
        vim.notify("Opencode AI: " .. error_msg, vim.log.levels.ERROR)
        if callback then callback(nil) end
      end
    else
      vim.notify("Opencode AI: Analysis failed", vim.log.levels.ERROR)
      if callback then callback(nil) end
    end
  end)
end

function M.explain_code(code, options, callback)
  if not M.config then
    vim.notify("Opencode AI: Not initialized. Call setup() first.", vim.log.levels.ERROR)
    return nil
  end
  
  local request_body = {
    code = code,
    context = options.context or M.config.context,
    language = options.language,
    explanation_level = options.level or "detailed",
  }
  
  http_request(M.config.api_endpoint .. "/explain", "POST", {
    ["Authorization"] = "Bearer " .. M.config.api_key,
  }, request_body, function(success, job_id, response_data)
    if success then
      local parse_success, data = parse_response(response_data)
      if parse_success and data.explanation then
        if callback then
          callback(data.explanation)
        else
          return data.explanation
        end
      else
        local error_msg = parse_success and data.error or "Invalid response"
        vim.notify("Opencode AI: " .. error_msg, vim.log.levels.ERROR)
        if callback then callback(nil) end
      end
    else
      vim.notify("Opencode AI: Explanation failed", vim.log.levels.ERROR)
      if callback then callback(nil) end
    end
  end)
end

function M.refactor_code(code, options, callback)
  if not M.config then
    vim.notify("Opencode AI: Not initialized. Call setup() first.", vim.log.levels.ERROR)
    return nil
  end
  
  local request_body = {
    code = code,
    context = options.context or M.config.context,
    language = options.language,
    style = options.style or "psr-12",
    focus = options.focus or "readability",
  }
  
  http_request(M.config.api_endpoint .. "/refactor", "POST", {
    ["Authorization"] = "Bearer " .. M.config.api_key,
  }, request_body, function(success, job_id, response_data)
    if success then
      local parse_success, data = parse_response(response_data)
      if parse_success and data.refactoring then
        if callback then
          callback(data.refactoring)
        else
          return data.refactoring
        end
      else
        local error_msg = parse_success and data.error or "Invalid response"
        vim.notify("Opencode AI: " .. error_msg, vim.log.levels.ERROR)
        if callback then callback(nil) end
      end
    else
      vim.notify("Opencode AI: Refactoring failed", vim.log.levels.ERROR)
      if callback then callback(nil) end
    end
  end)
end

function M.generate_code(specification, options, callback)
  if not M.config then
    vim.notify("Opencode AI: Not initialized. Call setup() first.", vim.log.levels.ERROR)
    return nil
  end
  
  local request_body = {
    specification = specification,
    context = options.context or M.config.context,
    language = options.language or "php",
    framework = options.framework,
    style = options.style or "psr-12",
  }
  
  http_request(M.config.api_endpoint .. "/generate", "POST", {
    ["Authorization"] = "Bearer " .. M.config.api_key,
  }, request_body, function(success, job_id, response_data)
    if success then
      local parse_success, data = parse_response(response_data)
      if parse_success and data.code then
        if callback then
          callback(data.code)
        else
          return data.code
        end
      else
        local error_msg = parse_success and data.error or "Invalid response"
        vim.notify("Opencode AI: " .. error_msg, vim.log.levels.ERROR)
        if callback then callback(nil) end
      end
    else
      vim.notify("Opencode AI: Code generation failed", vim.log.levels.ERROR)
      if callback then callback(nil) end
    end
  end)
end

function M.debug_lsp(diagnostics, options, callback)
  if not M.config then
    vim.notify("Opencode AI: Not initialized. Call setup() first.", vim.log.levels.ERROR)
    return nil
  end
  
  local request_body = {
    diagnostics = diagnostics,
    context = options.context or M.config.context,
    language = "php",
    linter = options.linter or "intelephense",
  }
  
  http_request(M.config.api_endpoint .. "/debug-lsp", "POST", {
    ["Authorization"] = "Bearer " .. M.config.api_key,
  }, request_body, function(success, job_id, response_data)
    if success then
      local parse_success, data = parse_response(response_data)
      if parse_success and data.solutions then
        if callback then
          callback(data.solutions)
        else
          return data.solutions
        end
      else
        local error_msg = parse_success and data.error or "Invalid response"
        vim.notify("Opencode AI: " .. error_msg, vim.log.levels.ERROR)
        if callback then callback(nil) end
      end
    else
      vim.notify("Opencode AI: LSP debug failed", vim.log.levels.ERROR)
      if callback then callback(nil) end
    end
  end)
end

-- Integration functions
function M.integrate_with_notices(notice_capture)
  if not M.config then return end
  
  -- Hook into notice capture system if available
  if notice_capture and M.config.integrations.notice_analyzer then
    local original_capture = notice_capture.capture_notice
    
    notice_capture.capture_notice = function(data)
      -- Send certain notices to AI for analysis
      if data.level == "ERROR" and data.source == "lsp" then
        vim.defer_fn(function()
          M.analyze_code(data.message, {
            context = "lsp_error_analysis",
            language = "php"
          }, function(analysis)
            if analysis then
              vim.notify("AI Analysis: " .. vim.fn.split(analysis, "\n")[1], vim.log.levels.INFO)
            end
          end)
        end, 2000)
      end
      
      -- Call original capture function
      return original_capture(data)
    end
  end
end

return M