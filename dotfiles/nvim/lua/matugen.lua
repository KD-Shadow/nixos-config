local M = {}

local function hex_to_rgb(hex)
  local r = tonumber(hex:sub(2, 3), 16) / 255
  local g = tonumber(hex:sub(4, 5), 16) / 255
  local b = tonumber(hex:sub(6, 7), 16) / 255
  return r, g, b
end

local function rgb_to_hex(r, g, b)
  return string.format("#%02x%02x%02x", math.floor(r * 255 + 0.5), math.floor(g * 255 + 0.5), math.floor(b * 255 + 0.5))
end

local function rgb_to_hsl(r, g, b)
  local max = math.max(r, g, b)
  local min = math.min(r, g, b)
  local l = (max + min) / 2
  local h, s

  if max == min then
    h, s = 0, 0
  else
    local d = max - min
    s = l > 0.5 and d / (2 - max - min) or d / (max + min)
    if max == r then
      h = (g - b) / d + (g < b and 6 or 0)
    elseif max == g then
      h = (b - r) / d + 2
    else
      h = (r - g) / d + 4
    end
    h = h / 6
  end

  return h, s, l
end

local function hsl_to_rgb(h, s, l)
  if s == 0 then
    return l, l, l
  end

  local function hue(p, q, t)
    if t < 0 then
      t = t + 1
    end
    if t > 1 then
      t = t - 1
    end
    if t < 1 / 6 then
      return p + (q - p) * 6 * t
    end
    if t < 1 / 2 then
      return q
    end
    if t < 2 / 3 then
      return p + (q - p) * (2 / 3 - t) * 6
    end
    return p
  end

  local q = l < 0.5 and l * (1 + s) or l + s - l * s
  local p = 2 * l - q
  return hue(p, q, h + 1 / 3), hue(p, q, h), hue(p, q, h - 1 / 3)
end

local function shift(hex, dh, ds, dl)
  local r, g, b = hex_to_rgb(hex)
  local h, s, l = rgb_to_hsl(r, g, b)
  h = (h + dh / 360) % 1
  s = math.min(1, math.max(0, s + ds))
  l = math.min(1, math.max(0, l + dl))
  return rgb_to_hex(hsl_to_rgb(h, s, l))
end

function M.setup()
  local palette = {
    bg = "#13131a",
    bg_container = "#1f1f26",
    bg_high = "#292931",
    fg = "#e4e1eb",
    fg_bright = "#e4e1eb",
    fg_muted = "#c6c5d5",
    border = "#908f9f",
    primary = "#bfc2ff",
    secondary = "#c1c2f5",
    tertiary = "#ffaaf5",
    error = "#ffb4ab",
    error_container = "#93000a",
  }

  local syn = {
    keyword = shift(palette.primary, 0, 0.05, -0.02),
    func = shift(palette.primary, -60, 0.02, 0),
    string = shift(palette.primary, -150, 0.02, 0),
    number = shift(palette.tertiary, 80, 0.05, -0.02),
    constant = shift(palette.tertiary, -20, 0.02, 0),
    type = shift(palette.primary, -30, 0.02, 0),
    property = shift(palette.tertiary, 5, 0.02, 0),
    operator = shift(palette.error, 60, -0.05, 0),
    parameter = shift(palette.primary, -20, -0.45, 0.05),
    comment = palette.border,
    punctuation = palette.fg_muted,
    variable = palette.fg,
    namespace = shift(palette.primary, -20, 0, -0.03),
    label = palette.tertiary,
    error = palette.error,
    added = shift(palette.primary, -150, 0, 0),
    modified = shift(palette.error, 60, 0, 0),
  }

  local transparent = false
  local function solid(color)
    return transparent and nil or color
  end

  vim.g.colors_name = "matugen"

  require("base16-colorscheme").setup({
    base00 = palette.bg,
    base01 = palette.bg_container,
    base02 = palette.bg_high,
    base03 = palette.border,
    base04 = palette.fg_muted,
    base05 = palette.fg,
    base06 = palette.fg,
    base07 = palette.fg_bright,
    base08 = syn.error,
    base09 = syn.number,
    base0A = syn.type,
    base0B = syn.string,
    base0C = syn.property,
    base0D = syn.func,
    base0E = syn.keyword,
    base0F = palette.error_container,
  })

  local hl = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hl("Normal", { fg = palette.fg, bg = solid(palette.bg) })
  hl("NormalNC", { fg = palette.fg, bg = solid(palette.bg) })
  hl("NormalFloat", { fg = palette.fg, bg = solid(palette.bg_container) })
  hl("NormalSB", { fg = palette.fg, bg = solid(palette.bg) })
  hl("FloatBorder", { fg = palette.border, bg = solid(palette.bg_container) })
  hl("FloatTitle", { fg = palette.primary, bg = solid(palette.bg_container), bold = true })
  hl("FloatFooter", { fg = palette.fg_muted, bg = solid(palette.bg_container) })
  hl("WinBar", { fg = palette.fg_muted, bg = solid(palette.bg), bold = true })
  hl("WinBarNC", { fg = palette.fg_muted, bg = solid(palette.bg) })
  hl("WinSeparator", { fg = palette.border, bg = solid(palette.bg) })
  hl("VertSplit", { fg = palette.border, bg = solid(palette.bg) })
  hl("EndOfBuffer", { fg = solid(palette.bg), bg = solid(palette.bg) })
  hl("NonText", { fg = palette.border, bg = solid(palette.bg) })
  hl("SpecialKey", { fg = palette.border, bg = solid(palette.bg) })
  hl("Whitespace", { fg = palette.bg_high, bg = solid(palette.bg) })
  hl("SignColumn", { fg = palette.fg_muted, bg = solid(palette.bg) })
  hl("FoldColumn", { fg = palette.border, bg = solid(palette.bg) })
  hl("LineNr", { fg = palette.border, bg = solid(palette.bg) })
  hl("LineNrAbove", { fg = palette.border, bg = solid(palette.bg) })
  hl("LineNrBelow", { fg = palette.border, bg = solid(palette.bg) })
  hl("CursorLineNr", { fg = palette.primary, bg = solid(palette.bg), bold = true })
  hl("CursorLine", { bg = solid(palette.bg_high) })
  hl("CursorLineFold", { bg = solid(palette.bg_high) })
  hl("CursorLineSign", { bg = solid(palette.bg_high) })
  hl("CursorColumn", { bg = solid(palette.bg_high) })
  hl("ColorColumn", { bg = solid(palette.bg_container) })
  hl("Terminal", { fg = palette.fg, bg = solid(palette.bg) })
  hl("StatusLine", { fg = palette.fg, bg = solid(palette.bg_container), bold = true })
  hl("StatusLineNC", { fg = palette.fg_muted, bg = solid(palette.bg) })
  hl("TabLine", { fg = palette.fg_muted, bg = solid(palette.bg) })
  hl("TabLineSel", { fg = palette.fg, bg = solid(palette.bg_high), bold = true })
  hl("TabLineFill", { bg = solid(palette.bg) })
  hl("MsgArea", { fg = palette.fg, bg = solid(palette.bg) })
  hl("MsgSeparator", { fg = palette.border, bg = solid(palette.bg) })
  hl("ModeMsg", { fg = palette.primary, bg = solid(palette.bg), bold = true })
  hl("MoreMsg", { fg = palette.primary, bg = solid(palette.bg) })
  hl("Question", { fg = palette.primary, bg = solid(palette.bg) })
  hl("ErrorMsg", { fg = palette.error, bg = solid(palette.bg), bold = true })
  hl("WarningMsg", { fg = syn.modified, bg = solid(palette.bg) })
  hl("Directory", { fg = syn.func, bold = true })
  hl("Title", { fg = palette.primary, bold = true })
  hl("QuickFixLine", { bg = solid(palette.bg_high), bold = true })

  hl("Pmenu", { fg = palette.fg, bg = solid(palette.bg_container) })
  hl("PmenuSel", { fg = palette.fg, bg = solid(palette.bg_high), bold = true })
  hl("PmenuKind", { fg = palette.primary, bg = solid(palette.bg_container) })
  hl("PmenuKindSel", { fg = palette.primary, bg = solid(palette.bg_high), bold = true })
  hl("PmenuExtra", { fg = palette.fg_muted, bg = solid(palette.bg_container) })
  hl("PmenuExtraSel", { fg = palette.fg_muted, bg = solid(palette.bg_high) })
  hl("PmenuSbar", { bg = solid(palette.bg_high) })
  hl("PmenuThumb", { bg = solid(palette.border) })
  hl("PmenuBorder", { fg = palette.border, bg = solid(palette.bg_container) })

  hl("Visual", { fg = palette.fg, bg = solid(palette.bg_high) })
  hl("VisualNOS", { fg = palette.fg, bg = solid(palette.bg_high) })
  hl("Search", { fg = palette.bg, bg = solid(syn.keyword) })
  hl("IncSearch", { fg = palette.bg, bg = solid(syn.number), bold = true })
  hl("CurSearch", { fg = palette.bg, bg = solid(syn.number), bold = true })
  hl("Substitute", { fg = palette.bg, bg = solid(syn.number), bold = true })
  hl("MatchParen", { fg = palette.primary, bg = solid(palette.bg_high), bold = true, underline = true })

  hl("DiffAdd", { fg = syn.added, bg = solid(palette.bg_container) })
  hl("DiffChange", { fg = syn.number, bg = solid(palette.bg_container) })
  hl("DiffDelete", { fg = palette.error, bg = solid(palette.bg_container) })
  hl("DiffText", { fg = palette.bg, bg = solid(syn.number), bold = true })
  hl("Added", { fg = syn.added })
  hl("Changed", { fg = syn.number })
  hl("Removed", { fg = palette.error })

  hl("LspReferenceText", { bg = solid(palette.bg_high) })
  hl("LspReferenceRead", { bg = solid(palette.bg_high) })
  hl("LspReferenceWrite", { bg = solid(palette.bg_high), underline = true })
  hl("LspInlayHint", { fg = palette.fg_muted, bg = solid(palette.bg_container), italic = true })
  hl("LspCodeLens", { fg = palette.fg_muted, italic = true })
  hl("LspSignatureActiveParameter", { fg = syn.number, bold = true })

  hl("Comment", { fg = syn.comment, italic = true })
  hl("Constant", { fg = syn.constant, bold = true })
  hl("String", { fg = syn.string })
  hl("Character", { fg = syn.string })
  hl("Number", { fg = syn.number })
  hl("Boolean", { fg = syn.number, bold = true })
  hl("Float", { fg = syn.number })
  hl("Identifier", { fg = syn.variable })
  hl("Function", { fg = syn.func, bold = true })
  hl("Statement", { fg = syn.keyword, bold = true, italic = true })
  hl("Conditional", { fg = syn.keyword, bold = true, italic = true })
  hl("Repeat", { fg = syn.keyword, bold = true, italic = true })
  hl("Label", { fg = syn.label })
  hl("Operator", { fg = syn.operator })
  hl("Keyword", { fg = syn.keyword, bold = true, italic = true })
  hl("Exception", { fg = syn.error, bold = true })
  hl("PreProc", { fg = syn.keyword })
  hl("Include", { fg = syn.keyword, italic = true })
  hl("Define", { fg = syn.keyword })
  hl("Macro", { fg = syn.func })
  hl("PreCondit", { fg = syn.keyword })
  hl("Type", { fg = syn.type, bold = true })
  hl("StorageClass", { fg = syn.type, bold = true })
  hl("Structure", { fg = syn.type, bold = true })
  hl("Typedef", { fg = syn.type, bold = true })
  hl("Special", { fg = syn.property })
  hl("SpecialChar", { fg = syn.operator })
  hl("Tag", { fg = syn.type })
  hl("Delimiter", { fg = syn.punctuation })
  hl("SpecialComment", { fg = syn.comment, italic = true })
  hl("Debug", { fg = syn.error })
  hl("Underlined", { fg = syn.func, underline = true })
  hl("Error", { fg = syn.error, bg = solid(palette.bg) })
  hl("Todo", { fg = syn.number, bg = solid(palette.bg_high), bold = true })

  hl("@comment", { fg = syn.comment, italic = true })
  hl("@comment.documentation", { fg = syn.comment, italic = true })
  hl("@comment.error", { fg = syn.error, italic = true })
  hl("@comment.warning", { fg = syn.number, italic = true })
  hl("@comment.todo", { fg = syn.keyword, bold = true, italic = true })
  hl("@comment.note", { fg = syn.func, italic = true })

  hl("@keyword", { fg = syn.keyword, bold = true, italic = true })
  hl("@keyword.function", { fg = syn.keyword, bold = true, italic = true })
  hl("@keyword.return", { fg = syn.keyword, bold = true, italic = true })
  hl("@keyword.operator", { fg = syn.keyword, bold = true, italic = true })
  hl("@keyword.import", { fg = syn.keyword, bold = true, italic = true })
  hl("@keyword.type", { fg = syn.keyword, bold = true, italic = true })
  hl("@keyword.coroutine", { fg = syn.keyword, bold = true, italic = true })
  hl("@keyword.directive", { fg = syn.keyword, bold = true, italic = true })
  hl("@keyword.directive.define", { fg = syn.keyword, bold = true, italic = true })
  hl("@keyword.exception", { fg = syn.keyword, bold = true, italic = true })
  hl("@conditional", { fg = syn.keyword, bold = true, italic = true })
  hl("@repeat", { fg = syn.keyword, bold = true, italic = true })
  hl("@exception", { fg = syn.error, italic = true })
  hl("@include", { fg = syn.keyword, italic = true })
  hl("@define", { fg = syn.keyword })
  hl("@preproc", { fg = syn.keyword })

  hl("@function", { fg = syn.func, bold = true })
  hl("@function.call", { fg = syn.func, bold = true })
  hl("@function.builtin", { fg = syn.func, bold = true })
  hl("@function.macro", { fg = syn.func, bold = true })
  hl("@function.method", { fg = syn.func, bold = true })
  hl("@function.method.call", { fg = syn.func, bold = true })
  hl("@method", { fg = syn.func, bold = true })
  hl("@method.call", { fg = syn.func, bold = true })
  hl("@constructor", { fg = syn.type, bold = true })

  hl("@type", { fg = syn.type, bold = true })
  hl("@type.builtin", { fg = syn.type, bold = true })
  hl("@type.definition", { fg = syn.type, bold = true })
  hl("@type.qualifier", { fg = syn.keyword, italic = true })

  hl("@variable", { fg = syn.variable })
  hl("@variable.builtin", { fg = syn.variable, italic = true })
  hl("@variable.parameter", { fg = syn.parameter, italic = true })
  hl("@variable.parameter.builtin", { fg = syn.parameter, italic = true })
  hl("@variable.member", { fg = syn.property })
  hl("@parameter", { fg = syn.parameter, italic = true })
  hl("@field", { fg = syn.property })
  hl("@property", { fg = syn.property })

  hl("@constant", { fg = syn.constant, bold = true })
  hl("@constant.builtin", { fg = syn.constant, bold = true })
  hl("@constant.macro", { fg = syn.constant, bold = true })
  hl("@number", { fg = syn.number })
  hl("@number.float", { fg = syn.number })
  hl("@boolean", { fg = syn.number, bold = true })
  hl("@character", { fg = syn.string })
  hl("@character.special", { fg = syn.operator })
  hl("@string", { fg = syn.string })
  hl("@string.documentation", { fg = syn.comment, italic = true })
  hl("@string.escape", { fg = syn.operator })
  hl("@string.regex", { fg = syn.number })
  hl("@string.special", { fg = syn.operator })
  hl("@string.special.url", { fg = syn.func, underline = true })
  hl("@string.special.symbol", { fg = syn.constant })

  hl("@operator", { fg = syn.operator })
  hl("@punctuation.bracket", { fg = syn.punctuation })
  hl("@punctuation.delimiter", { fg = syn.punctuation })
  hl("@punctuation.special", { fg = syn.operator })

  hl("@namespace", { fg = syn.namespace, bold = true })
  hl("@module", { fg = syn.namespace, bold = true })
  hl("@label", { fg = syn.label })
  hl("@tag", { fg = syn.type })
  hl("@tag.attribute", { fg = syn.property })
  hl("@tag.delimiter", { fg = syn.punctuation })
  hl("@attribute", { fg = syn.property })
  hl("@decorator", { fg = syn.func })

  hl("@lsp.type.class", { fg = syn.type, bold = true })
  hl("@lsp.type.struct", { fg = syn.type, bold = true })
  hl("@lsp.type.interface", { fg = syn.type, bold = true })
  hl("@lsp.type.enum", { fg = syn.type, bold = true })
  hl("@lsp.type.enumMember", { fg = syn.constant, bold = true })
  hl("@lsp.type.function", { fg = syn.func, bold = true })
  hl("@lsp.type.method", { fg = syn.func, bold = true })
  hl("@lsp.type.macro", { fg = syn.func, bold = true })
  hl("@lsp.type.keyword", { fg = syn.keyword, bold = true, italic = true })
  hl("@lsp.type.modifier", { fg = syn.keyword, italic = true })
  hl("@lsp.type.namespace", { fg = syn.namespace, bold = true })
  hl("@lsp.type.number", { fg = syn.number })
  hl("@lsp.type.operator", { fg = syn.operator })
  hl("@lsp.type.parameter", { fg = syn.parameter, italic = true })
  hl("@lsp.type.property", { fg = syn.property })
  hl("@lsp.type.string", { fg = syn.string })
  hl("@lsp.type.type", { fg = syn.type, bold = true })
  hl("@lsp.type.typeParameter", { fg = syn.type, bold = true })
  hl("@lsp.type.variable", { fg = syn.variable })
  hl("@lsp.type.event", { fg = syn.func, bold = true })
  hl("@lsp.type.comment", { fg = syn.comment, italic = true })
  hl("@lsp.type.decorator", { fg = syn.func })
  hl("@lsp.typemod.variable.defaultLibrary", { fg = syn.variable, italic = true })
  hl("@lsp.typemod.variable.readonly", { fg = syn.constant })

  hl("MiniFilesNormal", { fg = palette.fg, bg = solid(palette.bg_container) })
  hl("MiniFilesBorder", { fg = palette.border, bg = solid(palette.bg_container) })
  hl("MiniFilesTitle", { fg = palette.primary, bg = solid(palette.bg_container), bold = true })
  hl("MiniFilesTitleFocused", { fg = palette.primary, bg = solid(palette.bg_container), bold = true })
  hl("MiniFilesCursorLine", { bg = solid(palette.bg_high) })
  hl("MiniFilesDirectory", { fg = syn.func })
  hl("MiniFilesFile", { fg = palette.fg })

  hl("SnacksPicker", { fg = palette.fg, bg = solid(palette.bg_container) })
  hl("SnacksPickerBorder", { fg = palette.border, bg = solid(palette.bg_container) })
  hl("SnacksPickerTitle", { fg = palette.primary, bg = solid(palette.bg_container), bold = true })
  hl("SnacksPickerFooter", { fg = palette.fg_muted, bg = solid(palette.bg_container) })
  hl("SnacksPickerMatch", { fg = syn.keyword, bold = true })
  hl("SnacksPickerSelected", { fg = syn.keyword, bold = true })
  hl("SnacksPickerCursorLine", { bg = solid(palette.bg_high) })
  hl("SnacksPickerList", { fg = palette.fg, bg = solid(palette.bg_container) })
  hl("SnacksPickerListBorder", { fg = palette.border, bg = solid(palette.bg_container) })
  hl("SnacksPickerListCursorLine", { bg = solid(palette.bg_high) })
  hl("SnacksPickerInput", { fg = palette.fg, bg = solid(palette.bg_container) })
  hl("SnacksPickerInputBorder", { fg = palette.border, bg = solid(palette.bg_container) })
  hl("SnacksPickerInputTitle", { fg = palette.primary, bg = solid(palette.bg_container), bold = true })
  hl("SnacksPickerPreview", { fg = palette.fg, bg = solid(palette.bg) })
  hl("SnacksPickerPreviewBorder", { fg = palette.border, bg = solid(palette.bg) })
  hl("SnacksPickerPreviewTitle", { fg = syn.type, bg = solid(palette.bg), bold = true })
  hl("SnacksPickerBox", { fg = palette.fg, bg = solid(palette.bg_container) })
  hl("SnacksPickerBoxBorder", { fg = palette.border, bg = solid(palette.bg_container) })
  hl("SnacksPickerSearch", { fg = syn.keyword, bold = true })
  hl("SnacksPickerDir", { fg = palette.fg_muted })
  hl("SnacksPickerFile", { fg = palette.fg })
  hl("SnacksPickerPathIgnored", { fg = palette.border })
  hl("SnacksPickerPathHidden", { fg = palette.border })
  hl("SnacksPickerIcon", { fg = palette.primary })
  hl("SnacksPickerComment", { fg = syn.comment, italic = true })
  hl("SnacksPickerRule", { fg = palette.border })

  hl("SnacksDashboardNormal", { fg = palette.fg, bg = solid(palette.bg) })
  hl("SnacksDashboardHeader", { fg = palette.primary, bold = true })
  hl("SnacksDashboardTitle", { fg = palette.primary, bold = true })
  hl("SnacksDashboardKey", { fg = syn.keyword, bold = true })
  hl("SnacksDashboardDesc", { fg = palette.fg_muted })
  hl("SnacksDashboardIcon", { fg = syn.func })
  hl("SnacksDashboardFooter", { fg = palette.fg_muted })
  hl("SnacksDashboardDir", { fg = palette.fg_muted })
  hl("SnacksDashboardFile", { fg = palette.fg })
  hl("SnacksDashboardTerminal", { fg = palette.fg, bg = solid(palette.bg) })
  hl("SnacksDashboardSpecial", { fg = syn.number })

  hl("BlinkCmpMenu", { fg = palette.fg, bg = solid(palette.bg_container) })
  hl("BlinkCmpMenuBorder", { fg = palette.border, bg = solid(palette.bg_container) })
  hl("BlinkCmpMenuSelection", { fg = palette.fg, bg = solid(palette.bg_high), bold = true })
  hl("BlinkCmpScrollBarThumb", { bg = solid(palette.border) })
  hl("BlinkCmpScrollBarGutter", { bg = solid(palette.bg_container) })
  hl("BlinkCmpLabel", { fg = palette.fg })
  hl("BlinkCmpLabelMatch", { fg = syn.keyword, bold = true })
  hl("BlinkCmpLabelDeprecated", { fg = palette.fg_muted, strikethrough = true })
  hl("BlinkCmpLabelDescription", { fg = palette.fg_muted })
  hl("BlinkCmpDoc", { fg = palette.fg, bg = solid(palette.bg_container) })
  hl("BlinkCmpDocBorder", { fg = palette.border, bg = solid(palette.bg_container) })
  hl("BlinkCmpDocSeparator", { fg = palette.border })
  hl("BlinkCmpDocCursorLine", { bg = solid(palette.bg_high) })
  hl("BlinkCmpSignatureHelp", { fg = palette.fg, bg = solid(palette.bg_container) })
  hl("BlinkCmpSignatureHelpBorder", { fg = palette.border, bg = solid(palette.bg_container) })
  hl("BlinkCmpSignatureHelpActiveParameter", { fg = syn.number, bold = true })
  hl("BlinkCmpKindText", { fg = palette.fg_muted })
  hl("BlinkCmpKindMethod", { fg = syn.func })
  hl("BlinkCmpKindFunction", { fg = syn.func })
  hl("BlinkCmpKindConstructor", { fg = syn.type })
  hl("BlinkCmpKindField", { fg = syn.property })
  hl("BlinkCmpKindVariable", { fg = syn.variable })
  hl("BlinkCmpKindClass", { fg = syn.type })
  hl("BlinkCmpKindInterface", { fg = syn.type })
  hl("BlinkCmpKindModule", { fg = syn.namespace })
  hl("BlinkCmpKindProperty", { fg = syn.property })
  hl("BlinkCmpKindUnit", { fg = palette.fg_muted })
  hl("BlinkCmpKindValue", { fg = syn.constant })
  hl("BlinkCmpKindEnum", { fg = syn.type })
  hl("BlinkCmpKindKeyword", { fg = syn.keyword })
  hl("BlinkCmpKindSnippet", { fg = syn.number })
  hl("BlinkCmpKindColor", { fg = syn.property })
  hl("BlinkCmpKindFile", { fg = palette.fg })
  hl("BlinkCmpKindReference", { fg = syn.func })
  hl("BlinkCmpKindFolder", { fg = syn.namespace })
  hl("BlinkCmpKindEnumMember", { fg = syn.constant })
  hl("BlinkCmpKindConstant", { fg = syn.constant })
  hl("BlinkCmpKindStruct", { fg = syn.type })
  hl("BlinkCmpKindEvent", { fg = syn.error })
  hl("BlinkCmpKindOperator", { fg = syn.operator })
  hl("BlinkCmpKindTypeParameter", { fg = syn.type })

  hl("NoiceCmdline", { fg = palette.fg, bg = solid(palette.bg_container) })
  hl("NoiceCmdlineIcon", { fg = palette.primary })
  hl("NoiceCmdlineIconSearch", { fg = syn.keyword })
  hl("NoiceCmdlinePopup", { fg = palette.fg, bg = solid(palette.bg_container) })
  hl("NoiceCmdlinePopupBorder", { fg = palette.border, bg = solid(palette.bg_container) })
  hl("NoiceCmdlinePopupBorderSearch", { fg = syn.keyword, bg = solid(palette.bg_container) })
  hl("NoiceCmdlinePopupTitle", { fg = palette.primary, bg = solid(palette.bg_container), bold = true })
  hl("NoiceConfirm", { fg = palette.fg, bg = solid(palette.bg_container) })
  hl("NoiceConfirmBorder", { fg = palette.primary, bg = solid(palette.bg_container) })
  hl("NoicePopup", { fg = palette.fg, bg = solid(palette.bg_container) })
  hl("NoicePopupBorder", { fg = palette.border, bg = solid(palette.bg_container) })
  hl("NoiceMini", { fg = palette.fg_muted, bg = solid(palette.bg_container) })
  hl("NoiceFormatProgressDone", { fg = palette.primary, bg = solid(palette.bg_high), bold = true })
  hl("NoiceFormatProgressTodo", { fg = palette.border, bg = solid(palette.bg_container) })
  hl("NoiceLspProgressTitle", { fg = palette.fg_muted })
  hl("NoiceLspProgressClient", { fg = palette.primary })
  hl("NoiceVirtualText", { fg = palette.fg_muted })
end

if not package.loaded["matugen.signal"] then
  local signal = vim.uv.new_signal()
  signal:start(
    "sigusr1",
    vim.schedule_wrap(function()
      package.loaded["matugen"] = nil
      require("matugen").setup()
    end)
  )
  package.loaded["matugen.signal"] = signal
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("MatugenColors", { clear = true }),
  callback = function()
    if vim.g.colors_name ~= "matugen" then
      require("matugen").setup()
    end
  end,
})

return M
