class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.10.0"
  consolidatedBuildId = "273114"
  
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
  when "linux-arm64" then "1c5e5b4f8b1ea9d7711e9d7d6b6c3966139ff1dd71ffc4d2138c5f2974bb1421"
  when "linux-x64"   then "191ef9d1106499feb87eb978299224835972a09d7ed2f3ff8178c0d0ced4fcbe"
  when "osx-arm64"   then "2cdc9739d7effa5f41807340c834c73e4d5cef1729564be048e35511e86eadee"
  when "osx-x64"     then "d482eb6d688b79c0afa4d483a4fcd024a4adbeb6e20418420481e9a575002f03"
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

