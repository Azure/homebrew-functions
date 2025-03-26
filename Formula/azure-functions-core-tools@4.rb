class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.7030"
  consolidatedBuildId = "194"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "22931181a4c2891d0040077b7e27f145a1010bac74193ddec269acbea8a3a782"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "23b01e88f07497562935babe9249dc8c8d2a89732aff8c5ddee145bceb74557e"
  else
    funcArch = "osx-x64"
    funcSha = "d737bb109700dd1e677484bac0aeb4aabcc39c088e290f41557d6392b22144ff"
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

