class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.5382"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "0027a6c95f48e1b51649d6f7936c6dc9316b5a13bccbd30051906231bb8af582"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "d854016b821b64ad4cb682fecd890e56d7735025940bbfd66ceb06941a4c073f"
  else
    funcArch = "osx-x64"
    funcSha = "00c322d8e27f8029e33d3e77858f998bbdd7b4f4f0708367be413ce1e5e4b366"
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

