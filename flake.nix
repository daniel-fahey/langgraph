{
  description = "JupyterLab development environment with extensions and kernels";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python312;
        pythonPackages = python.pkgs;

        # Create a custom Python environment with JupyterLab and extensions
        pythonEnv = python.withPackages (ps: with ps; [
          # Core JupyterLab
          jupyterlab
          
          # Kernels
          # ansible-kernel
          # jupyter-c-kernel
          # rpy2             # R kernel
          
          # Extensions
          ipywidgets        # Interactive widgets
          jupyterlab-git    # Git integration
          jupytext          # Notebook/script conversion
          
          # Data science packages
          numpy             # Numerical computing
          matplotlib        # Plotting

          # Corrective RAG
          langchain-community
          tiktoken
          scikit-learn
          langchain
          langgraph
          langchain-ollama
        ]);

      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [ pythonEnv ];
        };
      });
}
