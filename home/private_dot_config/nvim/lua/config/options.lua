local g = vim.g

g.autoformat = false
g.snacks_animate = false

local opt = vim.opt

opt.breakindent = true
opt.cmdheight = 0
opt.colorcolumn = { 81, 101, 121 }
opt.fileformats = "unix,dos"
opt.relativenumber = false
opt.shiftwidth = 4
opt.shortmess:append { s = true }
opt.tabstop = 4
opt.wrap = true

-- https://github.com/nushell/integrations/blob/fd06ad143dccc5ba106338fb3355b1d9a34c1d4b/nvim/init.lua
opt.shell = "nu"
opt.shelltemp = false
opt.shellcmdflag = "--stdin --no-newline -c"
opt.shellredir = "o+e>"
opt.shellpipe = "| complete | update stderr { ansi strip } | tee { get stderr | save -f -r %s } | into record"

-- disable some default providers
for _, provider in ipairs { "node", "perl", "python3", "ruby" } do
  g["loaded_" .. provider .. "_provider"] = 0
end
