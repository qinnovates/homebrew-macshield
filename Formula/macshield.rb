class Macshield < Formula
  desc "Network-aware macOS security hardening"
  homepage "https://github.com/qinnovates/macshield"
  url "https://github.com/qinnovates/macshield/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "86825c3a024bfea086df0dab956f7e76d81f3c0fc69f10a995c19fd0ed050dc7"
  license "Apache-2.0"

  def install
    bin.install "macshield.sh" => "macshield"
    libexec.install "install.sh", "uninstall.sh"
    libexec.install "com.qinnovates.macshield.plist"
  end

  def post_install
    # Launch interactive setup in a new Terminal window
    # (post_install has no TTY, so we open a real terminal)
    setup_script = libexec / "install.sh"
    ohai "Opening interactive setup in a new Terminal window..."
    system "open", "-a", "Terminal", setup_script.to_s
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
