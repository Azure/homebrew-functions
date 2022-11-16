class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.4895"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "a83dd3c1f503e884a12c6155ab4a8e235816b5d986c339a3e235a50e8cb7c078"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "d180ed7c7e6fe9945fc2881425e5e6ff7944d251d83efe6062ed55b8b3307041"
  else
    funcArch = "osx-x64"
    funcSha = "0633f46623047b611a811aa068b248e15a2da77ca298f1161aa735b55306004d"
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

