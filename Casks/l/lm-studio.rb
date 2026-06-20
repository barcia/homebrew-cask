cask "lm-studio" do
  arch arm: "arm64", intel: "x64"
  livecheck_arch = on_arch_conditional intel: "x86", arm: "arm64"
  os macos: "darwin", linux: "linux"

  version "0.4.16,2"
  sha256 "1a3f2632b34d0d7343c858f6a777a689cdb19ace2d592a154b65d72ec11e102e"

  url_end = on_system_conditional linux: ".AppImage", macos: ".dmg"

  url "https://installers.lmstudio.ai/#{os}/#{arch}/#{version.tr(",", "-")}/LM-Studio-#{version.tr(",", "-")}-#{arch}#{url_end}"
  name "LM Studio"
  desc "Discover, download, and run local LLMs"
  homepage "https://lmstudio.ai/"

  livecheck do
    url "https://versions-prod.lmstudio.ai/update/#{os}/#{livecheck_arch}/#{version.csv.first}"
    strategy :json do |json|
      version = json["version"]
      build = json["build"]
      next if version.blank? || build.blank?

      "#{version},#{build}"
    end
  end

  auto_updates true

  on_macos do
    depends_on arch: :arm64

    app "LM Studio.app"

    uninstall quit: [
      "ai.elementlabs.lmstudio",
      "ai.elementlabs.lmstudio.helper",
    ]

    zap trash: [
      "~/Library/Application Support/LM Studio",
      "~/Library/Caches/ai.elementlabs.lmstudio",
      "~/Library/Caches/ai.elementlabs.lmstudio.ShipIt",
      "~/Library/HTTPStorages/ai.elementlabs.lmstudio",
      "~/Library/Logs/LM Studio",
      "~/Library/Preferences/ai.elementlabs.lmstudio.plist",
      "~/Library/Saved Application State/ai.elementlabs.lmstudio.savedState",
    ]
  end

  on_linux do
    app_image "LM-Studio-#{version.tr(",", "-")}-linux-#{arch}.AppImage", target: "LM Studio.AppImage"
  end
end
