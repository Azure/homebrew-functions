class AzureFunctionsCoreToolsV3Preview < Formula
  desc "Azure Function Cli 3.0"
  homepage "https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local#run-azure-functions-core-tools"
  url "https://functionscdn.azureedge.net/public/3.0.1740/Azure.Functions.Cli.osx-x64.3.0.1740.zip"
  version "3.0.1740"
  # make sure sha256 is lowercase.
  sha256 "8e1079f1c68c5f86d0cd6af1be83d961e2332db83f86a24aa22882d8253149bb"
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
