class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.5198"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "729a2baf90c2f074ee0c70a30c8c605dd7f22cb226a6893776a75f63bd6baf75"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "ad62fc32833c2cac5fa4d7628bfcb02f89c3a13c486c9729e529219b10ae9ffa"
  else
    funcArch = "osx-x64"
    funcSha = "2b2f24bd255f99be09c7b131622349892ee5caede5555860c57da979397b3ed2"
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

