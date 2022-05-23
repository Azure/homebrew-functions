class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.4544"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "014b98cea9b3c391af9096216fe15b3da10371929b8f61f48fa1ba0ddd56d561"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "1a553d9d4bcbe75cd1f9254cfca8508df237f1cc205e9aeb81900d16e1a7a922"
  else
    funcArch = "osx-x64"
    funcSha = "57a28dcd6714089fe8c6c54481abaa686e57e8143cfa2f2368627803e4662286"
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

