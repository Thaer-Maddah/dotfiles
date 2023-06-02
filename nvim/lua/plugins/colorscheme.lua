return {
  -- My colorscheme
  -- 'morhetz/gruvbox',
  { 'lunarvim/colorschemes' },
  -- 'Mofiqul/dracula.nvim',
  -- 'sainnhe/everforest',
  -- 'sainnhe/gruvbox-material',
     {
    "LazyVim/LazyVim",
    opts = {
        termguicolors = true,
        priority = 1000,
        colorscheme = 'system76',
        -- vim.cmd [[ colorscheme onedark]]
        },
}
}
