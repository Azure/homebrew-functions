class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.1.0"
  consolidatedBuildId = "227812"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "6b7edd4d557bc47dfc3381353f700ffd2673959d169e88227acb6cc0a89a6f0a"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "45cd70dea961c7d4ccd6f75a5f91e3b5f08375b468be9c2fceb1a9045995a1bb"
  else
    funcArch = "osx-x64"
    funcSha = "d5c8977c1e7b8839947a462a3f1dc74373af63581cb054a166f9d2928edc2161"
  end

  desc "Azure Functions Core Tools 4.0"
  homepage "https://docs.microsoft.com/azure/azure-functions/functions-run-local#run-azure-functions-core-tools"
  url "https://cdn.functions.azure.com/public/4.0.#{consolidatedBuildId}/Azure.Functions.Cli.#{funcArch}.#{funcVersion}.zip"
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

