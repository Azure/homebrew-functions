class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.7512"
  consolidatedBuildId = "226050"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "7b42a484ef2c4c42f08dcb838fc0a2bb733713d4a0a23eb28a1ba82a4d91f3f9"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "f485774d5dfc6c4774eea6eeff417bfc00e59e503630a92084faa6f96f4a6c12"
  else
    funcArch = "osx-x64"
    funcSha = "14c788558ebba8c2d834b562aae30393dcaf647f29584801c179c4d84aa0fd8e"
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

