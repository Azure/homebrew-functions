class AzureFunctionsCliPreview < Formula
  funcVersion = "5.0.0-preview.7"

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
  when "linux-arm64" then "cb109389075c2fe7fe38015860745b88b2304e706d1f44ac4972940a00f0884f"
  when "linux-x64"   then "1a5f846a04dc20e4fac6370d861a3ee77fee010c7e42d1f20243bcdb55e38b74"
  when "osx-arm64"   then "7e3bcec11005ba14083b47307cc544f6997891cabe0c7910b55511fd3f8e47e1"
  when "osx-x64"     then "bfbaa7c4b5a81d3ceb2cb59917fe6cca9b24f9804f1879be1107a5452afa8171"
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