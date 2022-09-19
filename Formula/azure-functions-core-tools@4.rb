class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.4785"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "496bdb3c4b25c2160d7767d34095b2d7ef36de8d6f251feba0fb2d81e9527e74"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "f6220d8746e1ee7fe288438e9644ecdc5f49c2a1653ee1fefcf1ca6d7600a0a1"
  else
    funcArch = "osx-x64"
    funcSha = "9b4e977941d50c2c68eec7cae1e175a0ce88b9a5444fd8ebff148ef6ace9c525"
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

