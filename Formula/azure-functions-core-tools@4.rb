class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.5858"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "55513bd1ea17f5cc19577384204e3c2074c99e62e6ae1c4340a22037ec2991d5"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "8f85f49e0a6c70421254a98832fd547038e7749f7426f0ac247fa0006078ea31"
  else
    funcArch = "osx-x64"
    funcSha = "e15a8dc3e9c0846d41dda55f7f2dd52620f5719e45968223c7198a8c2058f06f"
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

