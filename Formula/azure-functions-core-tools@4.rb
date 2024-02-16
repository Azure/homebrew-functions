class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.5530"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "b9254456ee56cda5b90674cf555dd553cdba6b6157f776c01cec5fabf21627c6"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "32818222ba09e69c3afe753fc4e886b93559cc4dbd3cdb66a0bfc0f17c9c9e20"
  else
    funcArch = "osx-x64"
    funcSha = "9f51e412d1fc9b5db40ee1fd2023c8794acc595656e6b4dbcaa536506d1607d6"
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

