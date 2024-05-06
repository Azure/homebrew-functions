class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.5700"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "83bb2f9c5039676d8295fe366019f122d3c34bd2d610c27ad906d152be3a2022"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "79f90794522e4075092d3b95c54d956059aba159a168673c7fb367a06c9aa963"
  else
    funcArch = "osx-x64"
    funcSha = "31a0c798bb66ae80f07e26c179c01a6e501fd18388537fcbea95b8d53817b60e"
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

