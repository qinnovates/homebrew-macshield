class Macshield < Formula
  desc "Read-only macOS security posture analyzer"
  homepage "https://github.com/qinnovates/macshield"
  url "https://github.com/qinnovates/macshield.git",
      branch: "main"
  version "1.0.0"
  license "Apache-2.0"

  depends_on xcode: ["16.0", :build]
  depends_on macos: :sonoma # macOS 14+

  def install
    system "swift", "build",
           "--disable-sandbox",
           "-c", "release"
    bin.install ".build/release/MacShield" => "macshield"
  end

  def caveats
    <<~EOS
      macshield is a read-only security analyzer. It does not modify your system.

      Usage:
        macshield audit                 Full security posture check
        macshield audit --format json   Machine-readable JSON output
        macshield scan                  Scan open ports
        macshield connections           Show active TCP connections
        macshield persistence           List non-Apple persistence items
        macshield permissions           Show TCC permissions

      For Full Disk Access (required for TCC queries):
        System Settings > Privacy & Security > Full Disk Access > add Terminal

      WARNING: macshield reports what it finds. A passing score does not mean
      your Mac is secure. See the McNamara Fallacy warning in the README.
    EOS
  end

  test do
    assert_match "macshield v#{version}", shell_output("#{bin}/macshield --version")
  end
end
