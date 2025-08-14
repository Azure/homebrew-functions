class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.1.2"
  consolidatedBuildId = "232642"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "07439057ba86144ca189e99a6e3f24f21f8397f18eb0ea4c3c0e0daed8dd60a6"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "264283c21ed7756adec4b257759530fbd689e58f3e38cc818f1c7c7bf3bb88a5"
  else
    funcArch = "osx-x64"
    funcSha = "fee9f8a84e0b2fef3f912bb67ee56371eceb45a1a9f16aabf4d0f44746c9c519"
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

