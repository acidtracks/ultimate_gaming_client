# webOS packaging & submission notes

## Status (2026-09-10)

| Item | State |
|------|-------|
| Rebrand Moonlight TV → Ultimate Gaming Client | done (`df683977`, `0c989c0e`, `1c69a1d6`) |
| webOS IPK packaging fix (OUTPUT_NAME) | done (`19d0f040`) |
| Brand identity — "Play, transmitted" mark | done, iteration 1 (`54621318`) |
| Linux desktop build | passes (CI: `.github/workflows/build-desktop.yml`) |
| webOS cross build + IPK | passes — `com.ultimate.gamingclient_1.6.36_arm.ipk` |
| `webosbrew-ipk-verify` | **passes** — see `docs/ipk-compat-report.md` |
| Homebrew manifest | generated — `dist/com.ultimate.gamingclient.manifest.json` |
| On-device test (real LG TV) | **pending** — TV was offline |
| Final brand art (vector finishing pass) | **pending** — needs a designer or Recraft/Firefly; brief: `deploy/branding/identity-proposal.html` |
| LG Content Store dev account / review | **pending** — manual, `seller.lgappstv.com` |

## Reading the compat report

`ultimate-gaming-client` (the app binary) and every `required lib` are **OK / SKIP**
across all webOS firmwares 1.2 → 11.2. `SKIP` means the firmware ships that lib
already, so our bundled copy is unused — not a problem.

The `:x:` / `:warning:` rows are all on the optional `ss4s-*` media backend
modules (from the unmodified `third_party/ss4s` submodule). Their names encode a
target webOS generation (`ss4s-ndl-webos4/5`, `ss4s-smp-webos3/4`, `ss4s-lgnc`):
the verifier flags each one on the firmwares it is *not* built for. At runtime the
app dlopen's whichever module matches the running firmware. This is identical to
upstream `mariotaku/moonlight-tv`, whose own CI runs this same check and ships.
**Not a blocker.**

## On-device test (run when the TV is reachable — alias `matv`)

```bash
# from repo root, with the webOS SDK env still set (see below)
export PATH="/tmp/ares-cli/ares-cli-rs-*/:$PATH"      # ares-install / ares-launch

# one-time: register the TV as an ares device (dev mode + devmode token on the TV)
ares-setup-device --add matv --info "host=192.168.1.114" --info "port=9922" \
  --info "username=prisoner" --info "privatekey=MaTV_webos"

# install + launch
ares-install -d matv dist/com.ultimate.gamingclient_1.6.36_arm.ipk
ares-launch  -d matv com.ultimate.gamingclient

# or straight over SSH (matches how com.limelight.webos is already sideloaded)
scp dist/com.ultimate.gamingclient_1.6.36_arm.ipk matv:/tmp/
ssh matv 'luna-send -n 1 -f luna://com.webos.appInstallService/dev/install \
  "{\"id\":\"com.ultimate.gamingclient\",\"ipkUrl\":\"/tmp/com.ultimate.gamingclient_1.6.36_arm.ipk\",\"subscribe\":true}"'
```

Test checklist on device: launches, pairs with the PC host (Moonshine/Sunshine),
starts a stream, controller input works, HEVC + HDR path (cf. the Limelight config
notes), and the app exits cleanly back to the TV home.

## Reproducing the webOS build

```bash
curl -sL -o /tmp/webos-ndk.tar.gz \
  https://github.com/openlgtv/buildroot-nc4/releases/download/webos-a38c582/arm-webos-linux-gnueabi_sdk-buildroot-x86_64.tar.gz
tar xzf /tmp/webos-ndk.tar.gz -C /tmp
/tmp/arm-webos-linux-gnueabi_sdk-buildroot/relocate-sdk.sh

# ares-package (IPK builder) — single binary, no dpkg needed
curl -sL https://github.com/webosbrew/ares-cli-rs/releases/download/v0.7.0/ares-cli-rs-v0.7.0-linux-x86_64.tar.gz \
  | tar xz -C /tmp/ares-cli

export PATH="/tmp/ares-cli/ares-cli-rs-v0.7.0-linux-x86_64:$PATH"
export TOOLCHAIN_FILE=/tmp/arm-webos-linux-gnueabi_sdk-buildroot/share/buildroot/toolchainfile.cmake
CI=1 ./scripts/webos/easy_build.sh -DCMAKE_BUILD_TYPE=Debug
# -> dist/com.ultimate.gamingclient_1.6.36_arm.ipk
```

Desktop build on a bleeding-edge distro (Arch): system mbedtls 4.x is
API-incompatible; build mbedtls 3.6.x into a prefix and
`-DCMAKE_PREFIX_PATH=<prefix>`.
