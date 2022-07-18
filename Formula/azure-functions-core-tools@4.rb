class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.4653"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "da56572816485d6d7d2aca06b23f95b7a54b58725975c27d0812991b37530792"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "8316d64b6ae2a94447afdc8c9e57fcc134525c957871d77996b336ce4d4e35b4"
  else
    funcArch = "osx-x64"
    funcSha = "c17fb7db3644bb123c6cc4c6c0a03ecad303d0484231e5cfc1357971828b796a"
  end

  desc "Azure Functions Core Tools 4.0"
  homepage "https://docs.microsoft.com/azure/azure-functions/functions-run-local#run-azure-functions-core-tools"
  url "https://functionscdn.azureedge.net/public/#{funcVersion}/Azure.Functions.Cli.#{funcArch}.#{funcVersion}.zip"
  sha256 funcSha
  version funcVersion
  head "https://github.com/Azure/azure-functions-core-tools"


  @@telemetry = "\n Telemetry \n --------- \n The Azure Functions Core tools collect usage data in order to help us improve your experience." \
  + "\n The data is anonymous and doesn\'t include any user specific or personal information. The data is collected by Microsoft." \
  + "\n \n You can opt-out of telemetry by setting the FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT environment variable to \'1\' or \'true\' using your favorite shell.\n"

  def install
    prefix.install Dir["*"]
    chmod 0555, prefix/"func"
    chmod 0555, prefix/"gozip"
    bin.install_symlink prefix/"func"
    begin
      FileUtils.touch(prefix/"telemetryDefaultOn.sentinel")
      print @@telemetry
    rescue Exception
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/func")
    system bin/"func", "new", "-l", "C#", "-t", "HttpTrigger", "-n", "confusedDevTest"
    assert_predicate testpath/"confusedDevTest/function.json", :exist?
  end
end

