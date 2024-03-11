class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.5571"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "665b951235ae4e00b1dfe37727e89a3d67e4904225e5fbad3420c5744a8b4b3c"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "275d6563f63f06b7956cfdb47c9fde6eba3261cb74cb7a72b29b938318cd65a0"
  else
    funcArch = "osx-x64"
    funcSha = "b673de9a2abbfad6366a77b7923a9ece9d8773dfbd1549ee28d42912561ae33a"
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

