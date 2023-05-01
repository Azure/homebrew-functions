class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.5148"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "3d706893415d1025a6f5229f78d37d9a9a1f64d67c62a0e29b9feab518f88450"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "1cba2b148c6f749e72d9e2c02397851605679f5632d8632c22140d972ac1c67c"
  else
    funcArch = "osx-x64"
    funcSha = "01b47e049b766484e17a053b4f6cc3ccd0af43f4d6db65025c52574c96949f5e"
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

