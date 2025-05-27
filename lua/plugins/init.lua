return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "dundalek/lazy-lsp.nvim",
    lazy = false,
    dependencies = {
      "neovim/nvim-lspconfig",
      { "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      local lsp_zero = require("lsp-zero")

      lsp_zero.on_attach(function(_, bufnr)
        -- see :help lsp-zero-keybindings to learn the available actions
        lsp_zero.default_keymaps({
          buffer = bufnr,
          preserve_mappings = false
        })
      end)

      require("lazy-lsp").setup {
        preferred_servers = {
          python = { "pyright" },
          nix = { "nixd" },
          lua = { "lua_ls" },
        },
        prefer_local = true,
        configs = {
          lua_ls = {
            settings = {
              Lua = {
                diagnostics = {
                  -- Get the language server to recognize the `vim` global
                  globals = { "vim" },
                },
              },
            },
          },
        },
      }

      vim.keymap.set("n", "gn", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next error" })
      vim.keymap.set("n", "gN", function() vim.diagnostic.jump({ count = -1, float = true}) end, { desc = "Previous error" })
    end,
  },

  {
    "joom/latex-unicoder.vim",
    lazy = false
  },

  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      workspaces = {
        {
          name = "Notes",
          path = "~/Documents/Notes/",
        },
      },
    },
  },

  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_method = "zathura"
    end
  },

  {
    "KeitaNakamura/tex-conceal.vim",
    lazy = false,
  },

  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    keys = { { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" } }
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { 'nvim-lua/plenary.nvim' },
    init = function()
      vim.keymap.set("n", "<leader>fp", "<cmd>Telescope commands<CR>", { desc = "Telescope find commands" })
    end
  },

  {
    'nvim-telescope/telescope-ui-select.nvim',
    lazy = false,
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
            }
          }
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {
            }
          }
        }
      })
      require("telescope").load_extension("ui-select")
    end
  },

  {
    "nosduco/remote-sshfs.nvim",
    lazy = false,
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {
      -- Refer to the configuration section below
      -- or leave empty for defaults
    },
  },

  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 3000,
      render = "compact",
      stages = "fade",
      top_down = "false",
    },
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true,         -- use a classic bottom cmdline for search
          -- command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false,           -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false,       -- add a border to hover docs and signature help
        },
      })

      require("notify").setup({
        background_colour = "#232530",
      })
    end
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    lazy = false,
    config = function()
      local dap, dapui, daptxt = require("dap"), require("dapui"), require("nvim-dap-virtual-text")

      dapui.setup()
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Set Breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Dap Continue" })
      vim.keymap.set("n", "<leader>dt", dapui.toggle, { desc = "Toggle Dap UI" })
      vim.keymap.set("n", "<leader>do", function() dapui.open({ reset = true }) end, { desc = "Open Dap UI" })
      vim.keymap.set("n", "<leader>dx", dapui.close, { desc = "Close Dap UI" })

      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
      }

      dap.configurations.c = {
        {
          name = "Launch",
          type = "gdb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = false,
        },
        {
          name = "Select and attach to process",
          type = "gdb",
          request = "attach",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          pid = function()
            local name = vim.fn.input('Executable name (filter): ')
            return require("dap.utils").pick_process({ filter = name })
          end,
          cwd = '${workspaceFolder}'
        },
        {
          name = 'Attach to gdbserver :1234',
          type = 'gdb',
          request = 'attach',
          target = 'localhost:1234',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}'
        },
      }
    end
  },



}
