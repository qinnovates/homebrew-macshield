class Macshield < Formula
  desc "Network-aware macOS security hardening"
  homepage "https://github.com/qinnovates/macshield"
  url "https://github.com/qinnovates/macshield/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "76a8709bcdc1efb9804da87506e7347500b4e0621b6ae220ad321e69c4e5308a"
  license "Apache-2.0"

  def install
    bin.install "macshield.sh" => "macshield"
    libexec.install "install.sh", "uninstall.sh"
    libexec.install "com.qinnovates.macshield.plist"
  end

  def post_install
    # Homebrew post_install has no TTY, so open a new Terminal window
    # with the interactive installer
    installer_path = libexec / "install.sh"
    ohai "Opening interactive installer in a new Terminal window..."
    system "osascript", "-e",
      "tell application \"Terminal\" to do script \"bash #{installer_path}\""
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
