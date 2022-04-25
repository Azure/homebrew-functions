class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.4483"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "988f35286c16b9d9ac8bad778707b7d2bd63d0c179bea0092c9e25b1b1193b50"
  else
    if Hardware::CPU.intel?
      funcArch = "osx-x64"
      funcSha = "392d95aba87576790655da023f5975bb582422505fcb0b1196f57db069d1bed5"
    else
      funcArch = "osx-arm64"
      funcSha = "6463403157f9db06075225e60960e31819448f0dbcdb6056770bd4b7ac608ee7"
    end
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

