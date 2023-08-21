class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.5274"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "fddcb8effbddeee09876547d1037a9582c56e1a6766237cf102c5740ade1ece2"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "8e9069b3c9504fac0c46cb897cf49409386b143ef2897a6e9ef7e97a0de874b7"
  else
    funcArch = "osx-x64"
    funcSha = "80101fc4039fe89da14042b7b1ef17538de1c60806b8536b6d0faa1648becddc"
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

