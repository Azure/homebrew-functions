class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.6594"
  consolidatedBuildId = "156"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "05eb235fc137f034f27167fe8e57cd048f0ca923382ba69089f889b3b8b72f6d"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "71b2cd24d645818d25ea66bfd42df41c798df83fb967a85529a42cf07fe43744"
  else
    funcArch = "osx-x64"
    funcSha = "e4f01767fbe31e6c222609248867d0cf67fc296a48eef0338689fa96aad52b1a"
  end

  desc "Azure Functions Core Tools 4.0"
  homepage "https://docs.microsoft.com/azure/azure-functions/functions-run-local#run-azure-functions-core-tools"
  url "https://functionscdn.azureedge.net/public/4.0.#{consolidatedBuildId}/Azure.Functions.Cli.#{funcArch}.#{funcVersion}.zip"
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

