class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.5312"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "dd31700568abf86df672f3964aae8d910dea5ac64c95d5cd0fe921db868c30ef"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "75ba4e3f7c141f033feb1e15f3768770f93b5a44ab0727ea07eb0db62664e56a"
  else
    funcArch = "osx-x64"
    funcSha = "fe455c389569c0789baa7feceaa4a2aec46273887f7795b5afb3fc591edfbc81"
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

