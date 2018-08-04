class AzureFunctionsCoreTools < Formula
  desc "Azure Function Cli 2.0"
  homepage "https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local#run-azure-functions-core-tools"
  url "https://functionscdn.azureedge.net/public/2.0.1-beta.34/Azure.Functions.Cli.osx-x64.2.0.1-beta.34.zip"
  version "2.0.1-beta.34"
  sha256 "44082fd0b056e8ed546b7515c60dde829952a6d63eed5ca4e009002396329c22"
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
