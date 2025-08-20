class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.2.1"
  consolidatedBuildId = "233491"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "84402b27fa13a205412117d433e993f1c329fc7eed555f028399f0a97e184c2a"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "fbb997c37362e83d4166bfea60d42a3160dd6c5b8c4d86b81faeef251b9e0851"
  else
    funcArch = "osx-x64"
    funcSha = "5c0e5289170d0fef3927e7bd1fd7ee9f1686ffb2d11894243d5310f2c2e44940"
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

