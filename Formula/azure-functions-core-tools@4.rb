class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.4590"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "0efb86ffd39cb9f94fa7dbe0e094870b224c2bc78be6e6a63a17abaeba7bb96b"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "a69d3d0c4dbee315695d3189f96ce883d69654da05d6ba45cc2b968f2ea87edd"
  else
    funcArch = "osx-x64"
    funcSha = "187680e2e39b99cfddeb9e4a95d0c71a55480fe5b1fd3173c71105102b365798"
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

