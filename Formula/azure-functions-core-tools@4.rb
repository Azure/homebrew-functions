class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.5801"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "96a3d52fe82728875b6052551de19a733b7b234aa7333261336cd74747ab368b"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "57c7e4d9bfc58d647a77ca9fc48326af7d703051d1c540b3363a9bc5f3217fb7"
  else
    funcArch = "osx-x64"
    funcSha = "7e6ae1d46c868e46fd56156cb452390bb7e208a788f95aa0c3409cefe4963214"
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

