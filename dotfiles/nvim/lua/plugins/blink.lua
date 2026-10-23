return {
  "saghen/blink.cmp",
  opts = {
    signature = {
      window = {
        border = "rounded",
      },
    },
    keymap = {
      preset = "default",
      ["<S-Tab>"] = {
        "snippet_backward",
        function(cmp)
          if cmp.is_visible() then
            return cmp.select_prev()
          end
        end,
        "fallback",
      },
      ["<Tab>"] = {
        "snippet_forward",
        function(cmp)
          if cmp.is_visible() then
            return cmp.select_next()
          end
          if cmp.is_active() then
            return cmp.show_and_insert()
          end
        end,
        "fallback",
      },
      ["<CR>"] = { "accept", "fallback" },
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },
    },
    completion = {
      trigger = {
        show_in_snippet = false,
      },
      keyword = {
        range = "full",
      },
      list = {
        selection = {
          preselect = false,
          auto_insert = false,
        },
      },
      menu = {
        border = "rounded",
        draw = {
          columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = "rounded",
        },
      },
    },
  },
}
