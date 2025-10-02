class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.3.0"
  consolidatedBuildId = "239852"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "e7971b72e355adc3f60f2bb9e3a77607a9c9604733c4aa4bd8e77bbe7bc26b9e"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "898867ca067dfa4656d82d7c2bd1ddd332e3f589a60a70a2decc9471f6c6ad73"
  else
    funcArch = "osx-x64"
    funcSha = "fcc14aaf7bb16cf7e0016f9fa014537ef68dbddb1b1de29f9cb38e7265d94e3e"
  end

  desc "Azure Functions Core Tools 4.0"
  homepage "https://docs.microsoft.com/azure/azure-functions/functions-run-local#run-azure-functions-core-tools"
  url "https://cdn.functions.azure.com/public/4.0.#{consolidatedBuildId}/Azure.Functions.Cli.#{funcArch}.#{funcVersion}.zip"
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

