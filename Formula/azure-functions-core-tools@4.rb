class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.6543"
  consolidatedBuildId = "123"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "f40341dbb0898d1b0be3931613274079b2b178ebb8f5bff454f00cd55830f989"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "88cb53c15b44ab239dd11679502aac2ccaa780022344966fe19a03cc6274042d"
  else
    funcArch = "osx-x64"
    funcSha = "75b279733952c92f01a833ab9fa90b57f74f5922e5b2a456f51b5276fc96b71d"
  end

  desc "Azure Functions Core Tools 4.0"
  homepage "https://docs.microsoft.com/azure/azure-functions/functions-run-local#run-azure-functions-core-tools"
  url "https://homebrewtest.blob.core.windows.net/6543/Azure.Functions.Cli.linux-x64.4.0.6413.zip"
  #url "https://functionscdn.azureedge.net/public/4.0.#{consolidatedBuildId}/Azure.Functions.Cli.#{funcArch}.#{funcVersion}.zip"
  #sha256 funcSha
  version funcVersion
  head "https://github.com/Azure/azure-functions-core-tools"


  @@telemetry = "\n Telemetry \n --------- \n The Azure Functions Core tools collect usage data in order to help us improve your experience." \
  + "\n The data is anonymous and doesn\'t include any user specific or personal information. The data is collected by Microsoft." \
  + "\n \n You can opt-out of telemetry by setting the FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT environment variable to \'1\' or \'true\' using your favorite shell.\n"

  def install
    prefix.install Dir["*"]
    chmod 0555, prefix/"func"
    chmod 0555, prefix/"gozip"
    chmod +w , prefix/"in-proc6/tools/python"
    chmod 0555, prefix/"in-proc6/tools/python"
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

