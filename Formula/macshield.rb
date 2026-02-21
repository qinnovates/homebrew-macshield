class Macshield < Formula
  desc "Network-aware macOS security hardening"
  homepage "https://github.com/qinnovates/macshield"
  url "https://github.com/qinnovates/macshield/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "63ddb993f79f1dd26e13906d21b63b7f49c524719887efa9702f46b737af9fdf"
  license "Apache-2.0"

  def install
    bin.install "macshield.sh" => "macshield"
    libexec.install "install.sh", "uninstall.sh"
    libexec.install "com.qinnovates.macshield.plist"
  end

  def post_install
    # Install LaunchAgent
    launch_agent_dir = Pathname.new("#{Dir.home}/Library/LaunchAgents")
    launch_agent_dir.mkpath
    plist_dest = launch_agent_dir / "com.qinnovates.macshield.plist"

    # Update plist to point to Homebrew-installed binary
    plist_content = (libexec / "com.qinnovates.macshield.plist").read
    plist_content.gsub!("/usr/local/bin/macshield", "#{HOMEBREW_PREFIX}/bin/macshield")
    plist_dest.write(plist_content)

    # Install sudoers fragment
    sudoers_content = <<~EOS
      # Installed by macshield (Homebrew) - network-aware security hardening
      # Grants passwordless access to ONLY these specific commands:
      Cmnd_Alias MACSHIELD_CMDS = \\
          /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on, \\
          /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode off, \\
          /usr/sbin/scutil --set ComputerName *, \\
          /usr/sbin/scutil --set LocalHostName *, \\
          /usr/sbin/scutil --set HostName *, \\
          /bin/launchctl bootout system/com.apple.netbiosd, \\
          /bin/launchctl enable system/com.apple.netbiosd, \\
          /bin/launchctl kickstart system/com.apple.netbiosd

      %admin ALL=(root) NOPASSWD: MACSHIELD_CMDS
    EOS

    sudoers_tmp = buildpath / "macshield.sudoers"
    sudoers_tmp.write(sudoers_content)

    ohai "Installing sudoers fragment (requires sudo)..."
    system "sudo", "cp", sudoers_tmp.to_s, "/etc/sudoers.d/macshield"
    system "sudo", "chmod", "440", "/etc/sudoers.d/macshield"
    system "sudo", "chown", "root:wheel", "/etc/sudoers.d/macshield"
  end

  def caveats
    <<~EOS
      macshield is installed and ready.

      To start the LaunchAgent (auto-harden on network changes):
        launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.qinnovates.macshield.plist

      To trust your current WiFi network:
        macshield trust

      To check current status:
        macshield --check

      The sudoers fragment at /etc/sudoers.d/macshield grants passwordless
      sudo for 8 specific commands only (stealth mode, hostname, NetBIOS).
      Review it with: cat /etc/sudoers.d/macshield
    EOS
  end

  test do
    assert_match "macshield v#{version}", shell_output("#{bin}/macshield --version")
  end
end
