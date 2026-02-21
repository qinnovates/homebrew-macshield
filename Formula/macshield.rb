class Macshield < Formula
  desc "Network-aware macOS security hardening"
  homepage "https://github.com/qinnovates/macshield"
  url "https://github.com/qinnovates/macshield/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "c62d0c8f839a2a731ad252db9599409989c74f4ea7d371287a7fbf11322e3dea"
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
