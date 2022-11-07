class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.4865"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "ee2e1f5a5ef2a16429d3193bb83c6e859ae2e59d61de57b0fde7c80c7eb4da7f"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "60c15310b9cda5a00a4f07a258bc649d1f998e7bb21df510803984fa7070f70e"
  else
    funcArch = "osx-x64"
    funcSha = "2e5d0e149b794aec3edb0bedf884733a82f39aa3f5e6f3d30354d0cf4ba8508f"
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

