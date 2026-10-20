 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#15121c',
    base01 = '#211e29',
    base02 = '#2b2833',
    base03 = '#948ea2',
    base04 = '#cbc3d8',
    base05 = '#e7e0ef',
    base06 = '#e7e0ef',
    base07 = '#e7e0ef',
    base08 = '#ffb4ab',
    base09 = '#ffacec',
    base0A = '#cebdff',
    base0B = '#cebdff',
    base0C = '#ffacec',
    base0D = '#cebdff',
    base0E = '#cebdff',
    base0F = '#e8ddff',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- telescope.nvim
  hi('TelescopeNormal',         { fg = '#e7e0ef',          bg = '#15121c' })
  hi('TelescopeBorder',         { fg = '#948ea2',             bg = '#15121c' })
  hi('TelescopePromptNormal',   { fg = '#e7e0ef',          bg = '#15121c' })
  hi('TelescopePromptBorder',   { fg = '#948ea2',             bg = '#15121c' })
  hi('TelescopePromptPrefix',   { fg = '#cebdff',             bg = '#15121c' })
  hi('TelescopePromptCounter',  { fg = '#cbc3d8',  bg = '#15121c' })
  hi('TelescopePromptTitle',    { fg = '#15121c',             bg = '#cebdff' })
  hi('TelescopePreviewTitle',   { fg = '#15121c',             bg = '#cebdff' })
  hi('TelescopeResultsTitle',   { fg = '#15121c',             bg = '#ffacec' })
  hi('TelescopeSelection',      { fg = '#e7e0ef',          bg = '#2b2833' })
  hi('TelescopeSelectionCaret', { fg = '#cebdff',             bg = '#2b2833' })
  hi('TelescopeMatching',       { fg = '#cebdff',             bold = true })

  -- mini.pick
  hi('MiniPickNormal',         { fg = '#e7e0ef',          bg = '#15121c' })
  hi('MiniPickBorder',         { fg = '#948ea2',             bg = '#15121c' })
  hi('MiniPickPrompt',   { fg = '#e7e0ef',          bg = '#15121c' })
  hi('MiniPickPromptPrefix',   { fg = '#cebdff',             bg = '#15121c' })
  hi('MiniPickBorderText',    { fg = '#15121c',             bg = '#cebdff' })
  hi('MiniPickMatchCurrent',      { fg = '#e7e0ef',          bg = '#2b2833' })
  hi('MiniPickPromptCaret', { fg = '#cebdff',             bg = '#2b2833' })
  hi('MiniPickMatchRanges',       { fg = '#cebdff',             bold = true })
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
