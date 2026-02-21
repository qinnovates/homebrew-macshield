class Macshield < Formula
  desc "Network-aware macOS security hardening"
  homepage "https://github.com/qinnovates/macshield"
  url "https://github.com/qinnovates/macshield/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "fe5a3e411b6a0c912f062981fdf71b74c274abc4582d3d0352a9736a68c8f141"
  license "Apache-2.0"

  def install
    bin.install "macshield.sh" => "macshield"
    libexec.install "install.sh", "uninstall.sh"
    libexec.install "com.qinnovates.macshield.plist"
  end

  def post_install
    ohai "Run the interactive setup to complete installation:"
    ohai "  macshield setup"
  end

  def caveats
    <<~EOS
      macshield is installed with LaunchAgent and sudoers authorization.

      To complete setup (DNS, proxy, network trust, hostname), run:
        macshield setup

      Quick start:
        macshield trust       # Trust your current WiFi network
        macshield --check     # See current status
        macshield --help      # All commands

      To revoke macshield's sudo authorization:
        sudo rm /etc/sudoers.d/macshield
    EOS
  end

  test do
    assert_match "macshield v#{version}", shell_output("#{bin}/macshield --version")
  end
end
