class AzureFunctionsCoreTools < Formula
  desc "Azure Function Cli 2.0"
  homepage "https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local#run-azure-functions-core-tools"
  url "https://functionscdn.azureedge.net/public/2.7.1575/Azure.Functions.Cli.osx-x64.2.7.1575.zip"
  version "2.7.1575"
  # make sure sha256 is lowercase.
  sha256 "e934a5ac4169ca4c4b34fda6f03b3a90cceaffa6e602087f9251101a491d15f3"
  head "https://github.com/Azure/azure-functions-core-tools"

  bottle :unneeded

  def install
    prefix.install Dir["*"]
    chmod 0555, prefix/"func"
    bin.install_symlink prefix/"func"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/func")
    system bin/"func", "new", "-l", "C#", "-t", "HttpTrigger", "-n", "confusedDevTest"
    assert_predicate testpath/"confusedDevTest/function.json", :exist?
  end
end
