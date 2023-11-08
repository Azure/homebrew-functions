class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.5455"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "d3cce9dd42479ccc3ce7c9518b8a7ed6f3ac126bd1973dc0a02f8774e4927117"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "0c8e333b0712edb5567703eb8e83c8290b877ae795e675ff89c3c4908b2754ff"
  else
    funcArch = "osx-x64"
    funcSha = "1012c9c9194292e0df560fb8789103c87325135b9e21bf2aaa7fc6342e9e5f31"
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

