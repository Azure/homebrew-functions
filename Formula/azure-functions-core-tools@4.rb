class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.5413"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "96bc6d43856d1e138596c7675433d916d55631bc2c5ca03e9da1b188be18b3e7"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "18e26e4b941f19988c810f2acc5901a771ba2ef44958acecdd9acd20d33f4d73"
  else
    funcArch = "osx-x64"
    funcSha = "0997317150b1738658f53a996f1fce197f2b4d75fb31039f8a233d387bc1cc95"
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

