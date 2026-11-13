class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.16.1"
  consolidatedBuildId = "316246"
  
  # Arch + OS matrix (intel == x86_64)
  os   = OS.mac? ? "osx" : "linux"
  arch = if Hardware::CPU.arm?
    "arm64"
  elsif Hardware::CPU.intel?
    "x64"
  else
    odie "Unsupported architecture: #{Hardware::CPU.arch}"
  end

  funcArch = "#{os}-#{arch}"

  funcSha = case funcArch
  when "linux-arm64" then "3075a7cfc5dd9cf525d2d3b50e42f1d2727a74bacac7767c8d4471e92f192a6f"
  when "linux-x64"   then "3fac67f50f3a25dff1dcb40514089726a93cb260d8d6cb064773961af3be16a6"
  when "osx-arm64"   then "cf50e58a04991ba3729a5e9fc875632aedf3b80de6cd204ea72ea9dc714f52fd"
  when "osx-x64"     then "ff879ee7e10c82db33c0c448eb03eeee69d4de2d30e8aa7ad87c4f7144248192"
  else
    odie "No SHA configured for #{funcArch}"
  end

  desc "Azure Functions Core Tools 4.0"
  homepage "https://docs.microsoft.com/azure/azure-functions/functions-run-local#run-azure-functions-core-tools"
  url "https://cdn.functions.azure.com/public/4.0.#{consolidatedBuildId}/Azure.Functions.Cli.#{funcArch}.#{funcVersion}.zip"
  sha256 funcSha
  version funcVersion
  head "https://github.com/Azure/azure-functions-core-tools"


  @@telemetry = "\n Telemetry \n --------- \n The Azure Functions Core tools collect usage data in order to help us improve your experience." \
  + "\n The data is anonymous and doesn\'t include any user specific or personal information. The data is collected by Microsoft." \
  + "\n \n You can opt-out of telemetry by setting the FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT environment variable to \'1\' or \'true\' using your favorite shell.\n"

  def install
    prefix.install Dir["*"]
    chmod 0555, prefix/"func"
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

