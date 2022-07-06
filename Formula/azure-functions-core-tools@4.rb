class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.4629"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "78902919ed002e38c23dbe2eafa678a31252545020a751559e9c0448e364f255"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "9d54341ab6d9075c96d2e5297b475b39cb34a0e5d36aa514a1eefd2893b35026"
  else
    funcArch = "osx-x64"
    funcSha = "f1ee4dd3a63fbaee7aa0191f28e4468bd0ab8112c9c800f16f5a384372561ae1"
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

