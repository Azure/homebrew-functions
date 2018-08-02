class AzureFunctionsCoreTools < Formula
  desc "Azure Function Cli 2.0"
  homepage "https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local#run-azure-functions-core-tools"
  url "https://functionscdn.azureedge.net/public/2.0.1-beta.34/Azure.Functions.Cli.osx-x64.2.0.1-beta.34.zip"
  version "2.0.1-beta.34"
  sha256 "44082FD0B056E8ED546B7515C60DDE829952A6D63EED5CA4E009002396329C22"
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
