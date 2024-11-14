class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.6610"
  consolidatedBuildId = "158"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "9cbda4e2984b052c3878581407592e7dac3f6348514e9a9127c511aeb91f8dab"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "a30cd3bd99da6f511d833af94b5442906588497e990bb46fd8ef6d5f1116fb6c"
  else
    funcArch = "osx-x64"
    funcSha = "a407df9ff6e803fcba6acff189ce3a301e2f17f96e3d3bb06bcaaf764c00cb8a"
  end

  desc "Azure Functions Core Tools 4.0"
  homepage "https://docs.microsoft.com/azure/azure-functions/functions-run-local#run-azure-functions-core-tools"
  url "https://functionscdn.azureedge.net/public/4.0.#{consolidatedBuildId}/Azure.Functions.Cli.#{funcArch}.#{funcVersion}.zip"
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

