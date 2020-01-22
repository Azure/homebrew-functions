class AzureFunctionsCoreToolsAT2 < Formula
  desc "Azure Functions Core Tools 2.0"
  homepage "https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local#run-azure-functions-core-tools"
  url "https://functionscdn.azureedge.net/public/2.7.1948/Azure.Functions.Cli.osx-x64.2.7.1948.zip"
  version "2.7.1948"
  # make sure sha256 is lowercase.
  sha256 "2ecb032723b15a6eb74cd4cc344e476b3ca880661f8d8f65f1e2f1246a04f672"
  head "https://github.com/Azure/azure-functions-core-tools"

  bottle :unneeded

  @@telemetry = "\n Telemetry \n --------- \n The Azure Functions Core tools collect usage data in order to help us improve your experience." \
  + "\n The data is anonymous and doesn\'t include any user specific or personal information. The data is collected by Microsoft." \
  + "\n \n You can opt-out of telemetry by setting the FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT environment variable to \'1\' or \'true\' using your favorite shell.\n"

  def install
    prefix.install Dir["*"]
    chmod 0555, prefix/"func"
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
