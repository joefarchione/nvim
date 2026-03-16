-- Find the broadest solution file (slnx > sln) in slns/ relative to root
-- Respects the user's selection via <leader>ns if one has been made
local function find_default_solution(root)
  local selected = _G._fsharp_get_selected_solution and _G._fsharp_get_selected_solution()
  if selected then return selected end
  local slns_dir = root .. "/slns"
  for _, ext in ipairs { "*.slnx", "*.sln" } do
    local matches = vim.fn.glob(slns_dir .. "/" .. ext, false, true)
    if #matches > 0 then return matches[1] end
  end
  return nil
end

return {
  root_markers = { "slns", ".git" },
  on_init = function(client)
    local root = client.root_dir or vim.uv.cwd()
    local sln = find_default_solution(root)
    if sln then
      client.settings.FSharp.workspacePath = sln
      client:notify("workspace/didChangeConfiguration", { settings = client.settings })
    end
  end,
  settings = {
    FSharp = {
      keywordsAutocomplete = true,
      externalAutocomplete = true,
      LSPv2 = true,
      UnusedOpens = true,
      SimplifyNames = true,
      UnusedDeclarations = true,
      UnionCaseStubGeneration = true,
      InterfaceStubGeneration = true,
      AbstractClassStubGeneration = true,
      RecordStubGeneration = true,
      CodeLenses = {
        Signature = { Enabled = true },
        References = { Enabled = true },
      },
      InlayHints = {
        ParameterNames = true,
        TypeAnnotations = true,
      },
      LineLens = { Enabled = "always" },
      PipelineHints = { Enabled = true },
    },
  },
}
