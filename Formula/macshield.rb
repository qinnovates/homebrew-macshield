class Macshield < Formula
  desc "Network-aware macOS security hardening"
  homepage "https://github.com/qinnovates/macshield"
  url "https://github.com/qinnovates/macshield/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "f99663b0637ba8c1c6c8d01fd6f10de1ae5490e08ab16ff17190965f1ae3208a"
  license "Apache-2.0"

  def install
    bin.install "macshield.sh" => "macshield"
    libexec.install "install.sh", "uninstall.sh"
    libexec.install "com.qinnovates.macshield.plist"
  end

  def post_install
    # Install LaunchDaemon (runs as root, no sudoers needed)
    daemon_dest = Pathname.new("/Library/LaunchDaemons/com.qinnovates.macshield.plist")

    # Update plist to point to Homebrew-installed binary
    plist_content = (libexec / "com.qinnovates.macshield.plist").read
    plist_content.gsub!("/usr/local/bin/macshield", "#{HOMEBREW_PREFIX}/bin/macshield")

    ohai "Installing LaunchDaemon (requires sudo)..."
    system "sudo", "tee", daemon_dest.to_s, :in => StringIO.new(plist_content)
    system "sudo", "chown", "root:wheel", daemon_dest.to_s
    system "sudo", "chmod", "644", daemon_dest.to_s
    system "sudo", "launchctl", "bootstrap", "system", daemon_dest.to_s
  end

  def caveats
    <<~EOS
      macshield is installed and ready.

      The LaunchDaemon runs as root (no sudoers fragment needed).
      It triggers automatically on WiFi network changes.

      To trust your current WiFi network:
        macshield trust

      To check current status:
        macshield --check

      The daemon is a pure bash script. Audit every line:
        cat $(brew --prefix macshield)/bin/macshield
    EOS
  end

  test do
    assert_match "macshield v#{version}", shell_output("#{bin}/macshield --version")
  end
end
