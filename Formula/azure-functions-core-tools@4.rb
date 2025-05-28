class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.7317"
  consolidatedBuildId = "219577"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "c0f931e44bb30d3a8960b86e0b6ab1ff09c940fa186d1c2d73e10f72ecb83a2e"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "3dfe2076f78439b086bd6d3b31ea9a2d7e175ee8b8f7b2c26250fad0149f92fc"
  else
    funcArch = "osx-x64"
    funcSha = "d12777795219b523ba46d1089ad2652dc21b57a9c524e30041c99577ccec2dc7"
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

