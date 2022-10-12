class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.4829"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "dcfb8238986821c041ad00bf6fc29f781a04cfb6a53c648750aceb566bf99713"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "72f1313da2eeb4276491b8b4343e9419a4790ee1a7ce86f98d02cfedfcb17a0c"
  else
    funcArch = "osx-x64"
    funcSha = "9f78e1b28add2d124fa3729f41b3425837452b75e43f7005b29490e8e59f2096"
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

