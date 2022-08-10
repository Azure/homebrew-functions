class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.4704"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "5aaeb5b51b15617c9e0d3187c57557e850ddab044e0df92670572a7036f80864"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "e29f4a1b1317e7f33b78e7c83f63307fda1a9a22ca306f3e9c8d28e9da78426c"
  else
    funcArch = "osx-x64"
    funcSha = "33570d3a7b6054b94de3d77456376aee5353ff88a6a4d366c0f81386b11e2f0d"
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

