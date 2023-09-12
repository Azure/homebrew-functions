class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.5348"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "e51e3f842c42cfa29f065f596de8be885b72e52d8c398b7d84cbcf3230b32f9e"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "ca9dd54ede66f0ab800a3ac1228b5f43965d80cbdfc182056aa636e3be691d1b"
  else
    funcArch = "osx-x64"
    funcSha = "6d31e1d26c066dee8956c47cac31c6a46276f808a91dbf0d201216ee28aecfa2"
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

