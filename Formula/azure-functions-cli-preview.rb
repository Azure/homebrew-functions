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
  when "linux-arm64" then "48b60a3893eee1b4efd25b47384b47fed6f2376b4ac163297b58d40019a57b5f"
  when "linux-x64"   then "8665f6a85daa27e9689af828c32a1678a9f8610ad56d2d981ebb82800af93af7"
  when "osx-arm64"   then "3d233df8af3ce970295acc2301b6d046459774013982fdace3b312ae31694ba3"
  when "osx-x64"     then "801df359b5831ad5d048e7e0b0d559a8de7efa7476db9ec247d2f475af8562cf"
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