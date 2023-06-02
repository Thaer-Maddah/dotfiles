return {
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate" , -- :MasonUpdate updates registry contents
        -- overrides require('nason.nvim').setup() 
        -- we use opts instead of require
        opts = {}
    }
}
