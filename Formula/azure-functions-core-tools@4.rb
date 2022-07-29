class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.4670"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "373018a3e1471351535073a3328cecc158fcdb7430b5bbf40a314b71e31b12d5"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "c8851b246144fe5d46231b612ed66625feef0fc47967d21796722e3b6ea70da6"
  else
    funcArch = "osx-x64"
    funcSha = "392c1b39f5c75fa899ce7720f7250c3e7996b9ee64bc6658e5ebbe817b756413"
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

