-- ================================================================================================
-- TITLE : intelephense (PHP Language Server) LSP Setup
-- LINKS :
--   > github: https://github.com/bmewburn/intelephense-docs
-- ================================================================================================

--- @param capabilities table LSP client capabilities (typically from nvim-cmp or similar)
--- @return nil
return function(capabilities)
	vim.lsp.config('intelephense', {
		capabilities = capabilities,
		settings = {
			intelephense = {
				files = {
					maxSize = 5000000, -- 5MB
					associations = {
						"*.php",
						"*.phtml",
						"*.blade.php",
					},
				},
				completion = {
					fullyQualifyGlobalConstantsAndFunctions = true,
					insertUseDeclaration = true,
					qualifyAllSymbols = true,
				},
				diagnostics = {
					enable = true,
					-- Disable some diagnostics for Laravel projects
					disable = {
						"undefinedClass", -- Laravel facades often appear undefined
						"undefinedFunction", -- Laravel helper functions
						"undefinedVariable", -- Laravel magic variables
					},
				},
				environment = {
					phpVersion = "8.3", -- Set to your PHP version
				},
			},
		},
		root_dir = vim.fs.root(0, {
			"composer.json",
			".git",
			"artisan", -- Laravel project marker
		}),
	})
end