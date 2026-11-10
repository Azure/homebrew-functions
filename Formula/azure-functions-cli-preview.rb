class AzureFunctionsCliPreview < Formula
  desc "Command-line tools for Azure Functions"
  homepage "https://github.com/Azure/azure-functions-core-tools"
  license "MIT"
  version "5.0.0-preview.5"

  depends_on :macos

  on_arm do
    url "https://cdn.functions.azure.com/public/cli/v5/5.0.0-preview.5/func-osx-arm64.tar.gz"
    sha256 "dac9f295d25942600610119173771a75646e736d2a04510bea5174c7e58a4e1c"
  end

  on_intel do
    url "https://cdn.functions.azure.com/public/cli/v5/5.0.0-preview.5/func-osx-x64.tar.gz"
    sha256 "9d66ae8417a58e9478f13b2f053277fedf0891e518e14c78da632e523dd84ac9"
  end

  def install
    libexec.install Dir["*"]
    chmod 0555, libexec/"func"
    bin.install_symlink libexec/"func"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/func --version")
  end
end