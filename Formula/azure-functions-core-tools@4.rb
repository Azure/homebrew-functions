class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.5174"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "280191dc2ef5cf5235139c1752786e10ce10c12fcaf4ee54117b5a582887ded4"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "3a66727dc07e706b120f0603dee4fe24e85f7ab215e44b3c20de6542dbeb0b70"
  else
    funcArch = "osx-x64"
    funcSha = "6d52a006eeef30d7db91ea5539190981070675775116ebf339ea16060d516da8"
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

