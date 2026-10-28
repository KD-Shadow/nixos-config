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

      ["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },

      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },

      ["<CR>"] = { "fallback" },
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
