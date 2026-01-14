-- ================================================================================================
-- TITLE : groovy-language-server LSP Setup
-- LINKS :
--   > github: https://github.com/GroovyLanguageServer/groovy-language-server
-- ================================================================================================

--- @param capabilities table LSP client capabilities (typically from nvim-cmp or similar)
--- @return nil
return function(capabilities)
	vim.lsp.config('groovy-language-server', {
		capabilities = capabilities,
		filetypes = { "groovy", "Jenkinsfile" },
	})
end