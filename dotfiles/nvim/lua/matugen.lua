 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#131316',
    base01 = '#1f1f22',
    base02 = '#2a2a2d',
    base03 = '#909099',
    base04 = '#c6c6cf',
    base05 = '#e4e2e5',
    base06 = '#e4e2e5',
    base07 = '#e4e2e5',
    base08 = '#ffb4ab',
    base09 = '#e7b8e1',
    base0A = '#c3c5da',
    base0B = '#bac5f3',
    base0C = '#e7b8e1',
    base0D = '#bac5f3',
    base0E = '#c3c5da',
    base0F = '#dfe1f6',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- telescope.nvim
  hi('TelescopeNormal',         { fg = '#e4e2e5',          bg = '#131316' })
  hi('TelescopeBorder',         { fg = '#909099',             bg = '#131316' })
  hi('TelescopePromptNormal',   { fg = '#e4e2e5',          bg = '#131316' })
  hi('TelescopePromptBorder',   { fg = '#909099',             bg = '#131316' })
  hi('TelescopePromptPrefix',   { fg = '#bac5f3',             bg = '#131316' })
  hi('TelescopePromptCounter',  { fg = '#c6c6cf',  bg = '#131316' })
  hi('TelescopePromptTitle',    { fg = '#131316',             bg = '#bac5f3' })
  hi('TelescopePreviewTitle',   { fg = '#131316',             bg = '#c3c5da' })
  hi('TelescopeResultsTitle',   { fg = '#131316',             bg = '#e7b8e1' })
  hi('TelescopeSelection',      { fg = '#e4e2e5',          bg = '#2a2a2d' })
  hi('TelescopeSelectionCaret', { fg = '#bac5f3',             bg = '#2a2a2d' })
  hi('TelescopeMatching',       { fg = '#bac5f3',             bold = true })

  -- mini.pick
  hi('MiniPickNormal',         { fg = '#e4e2e5',          bg = '#131316' })
  hi('MiniPickBorder',         { fg = '#909099',             bg = '#131316' })
  hi('MiniPickPrompt',   { fg = '#e4e2e5',          bg = '#131316' })
  hi('MiniPickPromptPrefix',   { fg = '#bac5f3',             bg = '#131316' })
  hi('MiniPickBorderText',    { fg = '#131316',             bg = '#bac5f3' })
  hi('MiniPickMatchCurrent',      { fg = '#e4e2e5',          bg = '#2a2a2d' })
  hi('MiniPickPromptCaret', { fg = '#bac5f3',             bg = '#2a2a2d' })
  hi('MiniPickMatchRanges',       { fg = '#bac5f3',             bold = true })
end

-- Register a signal handler for SIGUSR1 (matugen updates).
-- The handler re-requires this module, which re-runs the code below, so the
-- previous handle is stopped first; otherwise handlers double on every signal.
if _G.__matugen_signal then
  _G.__matugen_signal:stop()
  _G.__matugen_signal:close()
end

local signal = vim.uv.new_signal()
_G.__matugen_signal = signal
signal:start(
  'sigusr1',
  vim.schedule_wrap(function()
    package.loaded['matugen'] = nil
    require('matugen').setup()
  end)
)

return M
