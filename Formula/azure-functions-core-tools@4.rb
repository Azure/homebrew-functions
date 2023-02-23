class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.5030"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "7563c632c1d56ca7d672c82b4140d733a042a685b7fc1e9a3228c980e43314b2"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "bcb6c8afad6606371b06266fc876127142a04fd10a624bcd7055471cca91ef83"
  else
    funcArch = "osx-x64"
    funcSha = "c3bac534ee6398c6c9ef11a19e1d5d4cac8a1cec1473600a2cad6c61b6fba973"
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

