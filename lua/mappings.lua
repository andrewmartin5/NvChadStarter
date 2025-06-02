require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("i", "jk", "<ESC>")
map("i", "<C-BS>", "<C-W>")

map("v", "<A-j>", ":m '>+1<CR>gv=gv")
map("v", "<A-k>", ":m '<-2<CR>gv=gv")

map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map("n", "{", "}zz")
map("n", "}", "{zz")
map("n", "[", "]")
map("n", "]", "[")
map("v", "{", "}zz")
map("v", "}", "{zz")
map("v", "[", "]")
map("v", "]", "[")

map("x", "p", "\"_dP")
map("n", "d", "\"_d")
map("n", "D", "\"_D")

map("n", "`", "'")
map("n", "'", "`")

map("n", ":", ",")
map("n", ",", ";")

map("n", "#", "*NN")

map("i", "<S-Tab>", "<C-c><<i")

vim.cmd[[
  augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=200})
  augroup END
]]
