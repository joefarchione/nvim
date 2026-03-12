return {
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
