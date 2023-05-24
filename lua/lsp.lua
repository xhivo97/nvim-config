local wc = require("which-key")

local function execute_commands(commands)
  vim.cmd("belowright split")
  vim.cmd("resize 20")
  vim.cmd("term " .. table.concat(commands, " && "))
  vim.cmd("nnoremap <buffer> q :q<cr>")
  vim.cmd("normal! G")
end

local function fileExists(path)
  local f = io.open(path, "r")
  if f ~= nil then io.close(f) return true else return false end
end

local function execute_in_build_directory(commands)
  local workspaceFolders = vim.lsp.buf.list_workspace_folders()

  if #workspaceFolders > 0 then
    local srcDir = workspaceFolders[1]
    local buildDir = workspaceFolders[1] .. "/../.nvim-build"
    local cmakefile = srcDir .. "/CMakeLists.txt"
    
    
    if fileExists(cmakefile) then
      os.execute("mkdir -p " .. buildDir)
      if vim.loop.chdir(buildDir) then
        execute_commands(commands)
      else
        print("Could not create build directory.")
      end
    else
      print("No CMakeLists.txt found at workspace root.")
    end

  else
    print("No workspace folders found.")
  end
end

local function neofetch()
  execute_commands({ "neofetch" })
end

local function build()
  execute_in_build_directory({ "cmake ../src", "cmake --build ." })
end

local function run()
  execute_in_build_directory({ "cmake ../src", "cmake --build . --target run" })
end

local function test()
  execute_in_build_directory({
    "cmake ../src", "cmake --build . --target test" })
end

wc.register({ K = { vim.lsp.buf.hover, "Show hover information [LSP]" },
  ["<C-k>"] = { vim.lsp.buf.signature_help, "Signature help [LSP]" },
  g = {
    name = "+goto",
    D = { vim.lsp.buf.declaration, "Go to declaration [LSP]" },
    t = { vim.lsp.type_definition, "Go to type definition [LSP]" },
    d = { vim.lsp.buf.definition, "Go to definition [LSP]" },
    i = { vim.lsp.buf.implementation, "Go to implementation [LSP]" },
    r = { vim.lsp.buf.references, "Go to references [LSP]" },
  },
})

wc.register({
  e = { vim.diagnostic.open_float, "Open diagnostics [LSP]" },
  k = { vim.lsp.buf.hover, "Show hover info [LSP]" },
  r = {
    name = "+rename",
    n = { vim.lsp.buf.rename, "Rename [LSP]" },
  },
  c = {
    name = "+code",
    a = { vim.lsp.buf.code_action, "Code action [LSP]"},
    f = { function() vim.lsp.buf.format { async = true } end,
          "Code action [LSP]"},
  },
  w = {
    name = "+workspace",
    a = { vim.lsp.buf.add_workspace_folder, "Add workspace folder [LSP]" },
    r = { vim.lsp.buf.remove_workspace_folder,
          "Remove workspace folder [LSP]" },
    l = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, "List workspace folders [LSP]" },
  },
  b = {
    name = "+build",
    b = { build, "Build [CMake]" },
    r = { run, "Run [CMake]" },
    t = { test, "Test [CMake]" },
    n = { neofetch, "Neofetch [Demo]" },
  },
}, { prefix = "<leader>" })

local lsp_flags = {
  debounce_text_changes = 150,
}

require('lspconfig')['clangd'].setup{
  on_attach = on_attach,
  flags = lsp_flags,
}
