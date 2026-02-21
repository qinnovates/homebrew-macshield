class Macshield < Formula
  desc "Network-aware macOS security hardening"
  homepage "https://github.com/qinnovates/macshield"
  url "https://github.com/qinnovates/macshield/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "PLACEHOLDER_UPDATE_AFTER_RELEASE"
  license "Apache-2.0"

  def install
    bin.install "macshield.sh" => "macshield"
    libexec.install "install.sh", "uninstall.sh"
    libexec.install "com.qinnovates.macshield.plist"
  end

  def post_install
    # Run the interactive installer (same experience as ./install.sh)
    ohai "Launching interactive installer..."
    system "bash", (libexec / "install.sh").to_s
  end

  def caveats
    <<~EOS
      macshield is installed and ready.

      The LaunchAgent runs as YOUR user (not root).
      A sudoers fragment grants passwordless sudo for exact commands only.
      Privileged commands are elevated via sudo, not a root daemon.

      To trust your current WiFi network:
        macshield trust

      To check current status:
        macshield --check

      To revoke macshield's sudo authorization:
        sudo rm /etc/sudoers.d/macshield

      The agent is a pure bash script. Audit every line:
        cat $(brew --prefix macshield)/bin/macshield
    EOS
  end

  test do
    assert_match "macshield v#{version}", shell_output("#{bin}/macshield --version")
  end
end
