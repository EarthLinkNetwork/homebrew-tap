# Template of Casks/jotlio.rb in the public tap (docs/adr/0016-auto-update.md 3). The release
# workflow fills 0.3.1, a32f03f3e37f1302860caf2ce78a60caf359ff5f7372c0965020a52de079faf1 and EarthLinkNetwork/jotlio-releases (apps/mac/scripts/release/update-cask.sh) and
# commits it to the tap before the release (and its appcast) is published.
cask "jotlio" do
  version "0.3.1"
  sha256 "a32f03f3e37f1302860caf2ce78a60caf359ff5f7372c0965020a52de079faf1"

  url "https://github.com/EarthLinkNetwork/jotlio-releases/releases/download/jotlio-mac-v#{version}/Jotlio-#{version}.dmg"
  name "Jotlio"
  desc "Notes with fast capture, Markdown preview and sync"
  homepage "https://github.com/EarthLinkNetwork/jotlio-releases"

  # the appcast the app itself reads; Homebrew only uses it to see the newest version
  livecheck do
    url "https://github.com/EarthLinkNetwork/jotlio-releases/releases/latest/download/appcast.xml"
    strategy :sparkle, &:short_version
  end

  # the app updates itself (Sparkle, Jotlio > Check for Updates…)
  auto_updates true
  depends_on macos: :sequoia

  app "Jotlio.app"

  # a normal quit: Jotlio saves the text first and refuses while an import, backup or sync runs
  uninstall quit: "app.jotlio.mac"

  # The library (~/Library/Application Support/app.jotlio.mac) is the user's notes: never removed,
  # not even by `brew uninstall --zap`.
  zap trash: [
    "~/Library/Caches/app.jotlio.mac",
    "~/Library/HTTPStorages/app.jotlio.mac",
    "~/Library/Preferences/app.jotlio.mac.plist",
    "~/Library/Saved Application State/app.jotlio.mac.savedState",
  ]

  caveats <<~EOS
    Jotlio updates itself: it checks for updates automatically (you can turn this off in
    Settings > About) and installs a downloaded update when you quit it. `brew upgrade --greedy`
    is not needed.

    Your notes stay in ~/Library/Application Support/app.jotlio.mac. Homebrew never removes
    them, not even with `brew uninstall --zap`.
  EOS
end
