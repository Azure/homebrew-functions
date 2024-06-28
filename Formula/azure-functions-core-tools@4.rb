class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.5907"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "694761c8e0f2883cc61f32f2b24c0a033e0d3ac0171db37bdc3463c88ef806ac"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "41a77a4a379a85e737dfadad7cf12e8e19584d4c3c3786f45c142dde910b2188"
  else
    funcArch = "osx-x64"
    funcSha = "228a714644cf5428843b99b7289cd392b4aeabb18ea1373d1fcf9a30b17c2675"
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

