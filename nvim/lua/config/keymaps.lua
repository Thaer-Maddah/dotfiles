
-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
-- vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
--
-- NvimTreeToggle
local map = vim.api.nvim_set_keymap
map('n', '<C-o>', [[:NvimTreeToggle<CR>]], {})
-- map('n', '<C-o>', [[:NERDTreeToggle<CR>]], {})

-- remap for past last yanked text by user not by nvim
-- delete last yanked text in register and go to the text before deleted one
-- x for xnoremap
map('x', '<leader>p', "\"_dP", {})

-- Buffer keymaps 
map('n', '<C-right>', ":bn<cr>", {})
map('n', '<C-left>', ":bp<cr>", {})
map('n', '<C-x>', ":bd<cr>", {})
