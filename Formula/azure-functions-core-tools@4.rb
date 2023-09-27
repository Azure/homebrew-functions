class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.5390"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "9e7e977a354ad7c82794deaf42e4b46f03984a1bd3211fcea72059b8f4ad6225"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "a5c376c526f4e613aecfbf41e0933aba1e5287d91cb6abb4782dd96c69922206"
  else
    funcArch = "osx-x64"
    funcSha = "622a6d58191af7187dbb7f33183be1dfd4358f2ea9225e19f2373a7b78b5d061"
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

