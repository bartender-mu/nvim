-- ================================================================================================
-- TITLE : Opencode AI Neovim Plugin
-- ABOUT : Direct Opencode AI integration within Neovim
-- AUTHOR : Opencode AI Assistant
-- ================================================================================================

return {
  "nvim-lua/plenary.nvim",
  name = "opencode-ai",
  event = "VeryLazy",
  config = function()
    -- Initialize Opencode AI settings
    local api_key = os.getenv("OPENCODE_API_KEY") or vim.g.opencode_api_key
    
    -- Store Opencode AI configuration
    vim.g.opencode_config = {
      api_key = api_key,
      model = "big-pickle",
      context = "laravel_development",
      integrations = {
        lsp_analyzer = true,
        notice_analyzer = true,
        theme_consultant = true,
        workflow_assistant = true,
      },
      neovim = {
        version = vim.version().major .. "." .. vim.version().minor,
        config_path = vim.fn.stdpath("config"),
        project_detection = {
          patterns = {
            "composer.json",
            "artisan",
            ".git",
            "package.json"
          }
        }
      }
    }
    
    -- Register Opencode AI commands
    vim.api.nvim_create_user_command("OpencodeAsk", function(opts)
      local question = opts.args ~= "" and opts.args or nil
      vim.ui.input({ prompt = "Ask Opencode AI: ", default = question }, function(answer)
        if answer and answer ~= "" then
          vim.schedule(function()
            local response = opencode.ask(answer)
            -- Create floating window to display response
            local buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(response, "\n"))
            vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
            
            local win = vim.api.nvim_open_win(buf, 0, {
              relative = "editor",
              width = math.floor(vim.o.columns * 0.8),
              height = math.floor(vim.o.lines * 0.6),
              col = math.floor(vim.o.columns * 0.1),
              row = math.floor(vim.o.lines * 0.1),
              border = "rounded",
              title = " Opencode AI Response ",
              title_pos = "center",
              style = "minimal",
            })
            
            vim.api.nvim_win_set_option(win, "wrap", true)
            vim.api.nvim_win_set_option(win, "cursorline", true)
            vim.api.nvim_set_current_win(win)
            
            -- Local keymaps for response window
            local opts = { noremap = true, silent = true, buffer = buf }
            vim.keymap.set("n", "q", function() vim.api.nvim_win_close(win) end, opts)
            vim.keymap.set("n", "<Esc>", function() vim.api.nvim_win_close(win) end, opts)
          end)
        end
      end)
    end, { nargs = "*", desc = "Ask Opencode AI a question" })
    
    vim.api.nvim_create_user_command("OpencodeAnalyze", function()
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      local content = table.concat(lines, "\n")
      local filename = vim.fn.expand("%:t")
      
      vim.schedule(function()
        local analysis = opencode.analyze_code(content, {
          filetype = vim.bo.filetype,
          filename = filename,
          context = "laravel_development"
        })
        
        -- Display analysis in floating window
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(analysis, "\n"))
        vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
        
        local win = vim.api.nvim_open_win(buf, 0, {
          relative = "editor",
          width = math.floor(vim.o.columns * 0.8),
          height = math.floor(vim.o.lines * 0.6),
          col = math.floor(vim.o.columns * 0.1),
          row = math.floor(vim.o.lines * 0.1),
          border = "rounded",
          title = " Opencode AI Code Analysis ",
          title_pos = "center",
          style = "minimal",
        })
        
        vim.api.nvim_win_set_option(win, "wrap", true)
        vim.api.nvim_win_set_option(win, "cursorline", true)
        vim.api.nvim_set_current_win(win)
        
        -- Local keymaps
        local opts = { noremap = true, silent = true, buffer = buf }
        vim.keymap.set("n", "q", function() vim.api.nvim_win_close(win) end, opts)
        vim.keymap.set("n", "<Esc>", function() vim.api.nvim_win_close(win) end, opts)
      end)
    end, { desc = "Analyze current buffer with Opencode AI" })
    
    vim.api.nvim_create_user_command("OpencodeExplain", function(opts)
      local range = opts.range
      local lines = {}
      
      if range then
        lines = vim.api.nvim_buf_get_lines(0, range.line1 - 1, range.line2, false)
      else
        lines = vim.api.nvim_buf_get_lines(0, vim.fn.line(".") - 1, vim.fn.line("."), false)
      end
      
      local content = table.concat(lines, "\n")
      
      vim.schedule(function()
        local explanation = opencode.explain_code(content, {
          context = "laravel_development",
          language = "php"
        })
        
        -- Display explanation in floating window
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(explanation, "\n"))
        vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
        
        local win = vim.api.nvim_open_win(buf, 0, {
          relative = "editor",
          width = math.floor(vim.o.columns * 0.8),
          height = math.floor(vim.o.lines * 0.6),
          col = math.floor(vim.o.columns * 0.1),
          row = math.floor(vim.o.lines * 0.1),
          border = "rounded",
          title = " Opencode AI Explanation ",
          title_pos = "center",
          style = "minimal",
        })
        
        vim.api.nvim_win_set_option(win, "wrap", true)
        vim.api.nvim_win_set_option(win, "cursorline", true)
        vim.api.nvim_set_current_win(win)
        
        -- Local keymaps
        local opts = { noremap = true, silent = true, buffer = buf }
        vim.keymap.set("n", "q", function() vim.api.nvim_win_close(win) end, opts)
        vim.keymap.set("n", "<Esc>", function() vim.api.nvim_win_close(win) end, opts)
      end)
    end, { range = true, nargs = 0, desc = "Explain code with Opencode AI" })
    
    vim.api.nvim_create_user_command("OpencodeRefactor", function(opts)
      local range = opts.range
      local lines = {}
      
      if range then
        lines = vim.api.nvim_buf_get_lines(0, range.line1 - 1, range.line2, false)
      else
        lines = vim.api.nvim_buf_get_lines(0, vim.fn.line(".") - 1, vim.fn.line("."), false)
      end
      
      local content = table.concat(lines, "\n")
      
      vim.schedule(function()
        local refactor = opencode.refactor_code(content, {
          context = "laravel_development",
          style = "psr-12",
          focus = "maintainability"
        })
        
        -- Display refactor suggestions in floating window
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(refactor, "\n"))
        vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
        
        local win = vim.api.nvim_open_win(buf, 0, {
          relative = "editor",
          width = math.floor(vim.o.columns * 0.8),
          height = math.floor(vim.o.lines * 0.6),
          col = math.floor(vim.o.columns * 0.1),
          row = math.floor(vim.o.lines * 0.1),
          border = "rounded",
          title = " Opencode AI Refactoring Suggestions ",
          title_pos = "center",
          style = "minimal",
        })
        
        vim.api.nvim_win_set_option(win, "wrap", true)
        vim.api.nvim_win_set_option(win, "cursorline", true)
        vim.api.nvim_set_current_win(win)
        
        -- Local keymaps
        local opts = { noremap = true, silent = true, buffer = buf }
        vim.keymap.set("n", "q", function() vim.api.nvim_win_close(win) end, opts)
        vim.keymap.set("n", "<Esc>", function() vim.api.nvim_win_close(win) end, opts)
      end)
    end, { range = true, nargs = 0, desc = "Refactor code with Opencode AI" })
    
    vim.api.nvim_create_user_command("OpencodeDebug", function()
      -- Get current LSP diagnostics
      local diagnostics = vim.diagnostic.get(0)
      if #diagnostics > 0 then
        local diag_content = {}
        for _, diag in ipairs(diagnostics) do
          table.insert(diag_content, string.format(
            "File: %s, Line: %d, Message: %s, Severity: %s",
            diag.filename or "unknown",
            diag.lnum + 1,
            diag.message,
            vim.diagnostic.severity[diag.severity]
          ))
        end
        
        vim.schedule(function()
          local debug_help = opencode.debug_lsp(diag_content, {
            context = "laravel_development"
          })
          
          -- Display debug help in floating window
          local buf = vim.api.nvim_create_buf(false, true)
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(debug_help, "\n"))
          vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
          
          local win = vim.api.nvim_open_win(buf, 0, {
            relative = "editor",
            width = math.floor(vim.o.columns * 0.8),
            height = math.floor(vim.o.lines * 0.6),
            col = math.floor(vim.o.columns * 0.1),
            row = math.floor(vim.o.lines * 0.1),
            border = "rounded",
            title = " Opencode AI LSP Debug ",
            title_pos = "center",
            style = "minimal",
          })
          
          vim.api.nvim_win_set_option(win, "wrap", true)
          vim.api.nvim_win_set_option(win, "cursorline", true)
          vim.api.nvim_set_current_win(win)
          
          -- Local keymaps
          local opts = { noremap = true, silent = true, buffer = buf }
          vim.keymap.set("n", "q", function() vim.api.nvim_win_close(win) end, opts)
          vim.keymap.set("n", "<Esc>", function() vim.api.nvim_win_close(win) end, opts)
        end)
      else
        vim.notify("No LSP diagnostics to debug", vim.log.levels.INFO)
      end
    end, { desc = "Debug LSP issues with Opencode AI" })
    
    vim.api.nvim_create_user_command("OpencodeGenerate", function(opts)
      local spec = opts.args ~= "" and opts.args or nil
      
      if not spec then
        vim.ui.input({ prompt = "Generate code from specification: " }, function(input)
          if input and input ~= "" then
            spec = input
          end
        end)
      end
      
      if spec then
        vim.schedule(function()
          local generated_code = opencode.generate_code(spec, {
            language = "php",
            framework = "laravel",
            style = "psr-12"
          })
          
          -- Display generated code in floating window
          local buf = vim.api.nvim_create_buf(false, true)
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(generated_code, "\n"))
          vim.api.nvim_buf_set_option(buf, "filetype", "php")
          
          local win = vim.api.nvim_open_win(buf, 0, {
            relative = "editor",
            width = math.floor(vim.o.columns * 0.8),
            height = math.floor(vim.o.lines * 0.6),
            col = math.floor(vim.o.columns * 0.1),
            row = math.floor(vim.o.lines * 0.1),
            border = "rounded",
            title = " Opencode AI Generated Code ",
            title_pos = "center",
            style = "minimal",
          })
          
          vim.api.nvim_win_set_option(win, "wrap", true)
          vim.api.nvim_win_set_option(win, "cursorline", true)
          vim.api.nvim_set_current_win(win)
          
          -- Local keymaps
          local opts = { noremap = true, silent = true, buffer = buf }
          vim.keymap.set("n", "q", function() vim.api.nvim_win_close(win) end, opts)
          vim.keymap.set("n", "<Esc>", function() vim.api.nvim_win_close(win) end, opts)
        end)
      end
    end, { nargs = "*", desc = "Generate code from specification with Opencode AI" })
    
    -- Register keymaps for quick access
    vim.keymap.set('n', '<leader>oa', function()
      vim.cmd('OpencodeAsk')
    end, { noremap = true, silent = true, desc = "Quick Opencode AI ask" })
    
    vim.keymap.set('n', '<leader>oc', function()
      vim.cmd('OpencodeAnalyze')
    end, { noremap = true, silent = true, desc = "Quick Opencode AI analyze" })
    
    vim.keymap.set('n', '<leader>oe', function()
      vim.cmd('OpencodeExplain')
    end, { noremap = true, silent = true, desc = "Quick Opencode AI explain" })
    
    vim.keymap.set('n', '<leader>or', function()
      vim.cmd('OpencodeRefactor')
    end, { noremap = true, silent = true, desc = "Quick Opencode AI refactor" })
    
    vim.keymap.set('n', '<leader>od', function()
      vim.cmd('OpencodeDebug')
    end, { noremap = true, silent = true, desc = "Quick Opencode AI debug" })
    
    vim.keymap.set('n', '<leader>og', function()
      vim.cmd('OpencodeGenerate')
    end, { noremap = true, silent = true, desc = "Quick Opencode AI generate" })
    
    -- Integrate with existing notice capture system
    vim.defer_fn(function()
      local ok, capture = pcall(require, "utils.notice-capture")
      if ok and capture then
        -- Add notice for Opencode AI initialization
        capture.capture_notice({
          source = "opencode",
          level = "INFO", 
          message = "Opencode AI plugin initialized with full Neovim integration",
          title = "System"
        })
      end
    end, 1000)
    
    vim.notify("Opencode AI Neovim plugin loaded successfully!", vim.log.levels.INFO, {
      title = "System"
    })
  end,
}