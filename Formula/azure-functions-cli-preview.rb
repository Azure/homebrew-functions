class AzureFunctionsCliPreview < Formula
  funcVersion = "5.0.0-preview.5"

  # Arch + OS matrix (intel == x86_64)
  os   = OS.mac? ? "osx" : "linux"
  arch = if Hardware::CPU.arm?
    "arm64"
  elsif Hardware::CPU.intel?
    "x64"
  else
    odie "Unsupported architecture: #{Hardware::CPU.arch}"
  end

  funcArch = "#{os}-#{arch}"

  funcSha = case funcArch
  when "linux-arm64" then "a1c100f917e131d12001e1f38dd4699564b74bf00ff4ebc09147c7329d3cc22b"
  when "linux-x64"   then "8ef4fcdd1cc6311ede7beb98614ed3076f18e167c001b37a0a04dcb373a267d9"
  when "osx-arm64"   then "ea5f33758c14a99e50a05f57203cf65c3792f98df70993b1c1699c05342a5216"
  when "osx-x64"     then "bd6e0748f1194aa4a55cd987a6823c05805ceb999480d4c0eb861ecfe08e8338"
  else
    odie "No SHA configured for #{funcArch}"
  end

  desc "Azure Functions CLI 5.0"
  homepage "https://docs.microsoft.com/azure/azure-functions/functions-run-local#run-azure-functions-core-tools"
  url "https://cdn.functions.azure.com/public/cli/v5/#{funcVersion}/func-#{funcArch}.tar.gz"
  sha256 funcSha
  version funcVersion
  head "https://github.com/Azure/azure-functions-core-tools"


  @@telemetry = "\n Telemetry \n --------- \n The Azure Functions CLI collects usage data in order to help us improve your experience." \
  + "\n The data is anonymous and doesn\'t include any user specific or personal information. The data is collected by Microsoft." \
  + "\n \n You can opt-out of telemetry by setting the FUNC_CLI_TELEMETRY_OPTOUT environment variable to \'1\' or \'true\' using your favorite shell.\n"

  def install
    prefix.install Dir["*"]
    chmod 0555, prefix/"func"
    bin.install_symlink prefix/"func"
    print @@telemetry
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/func --version")
  end
end
