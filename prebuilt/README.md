# Launcher prebuilts

Copied unchanged from RisingOS-Revived `vendor/addons` (seventeen,
67474d59 "addons: Update Lawnchair and Lawnicons", 2026-08-28), together
with their Android.bp files, permission allowlist and overlay. Lawnicons
has since moved on to 2.19.0, the GitHub release (Lawnicons.2.19.0.apk,
SHA-256 5ed67a0338c207bd0f8c44392dedbae8d0449fef5c8d773a202451d42bbd8cdd,
signed with the same Lawnchair key).

Before shipping a newer APK, check that it keeps the package name and the
signing key (`apksigner verify --print-certs`) and, for Lawnchair, that every
privileged permission it asks for is in privapp-permissions-app.lawnchair.xml:
an unlisted one stops the system from booting. Lawnchair's nightlies are
another app (`app.lawnchair.nightly`), not an update.

| App | Version | License | Source |
|---|---|---|---|
| Lawnchair (`app.lawnchair`) | 15 Beta 3 | GPL-3.0 | https://github.com/LawnchairLauncher/lawnchair |
| Lawnicons (`app.lawnchair.lawnicons`) | 2.19.0 | Apache-2.0 | https://github.com/LawnchairLauncher/lawnicons |

QuickSwitch (Catalyxx Lab > User interface > Home app) switches between
Catalyxx Launcher (Launcher3), the Pixel Launcher and Lawnchair. Lawnchair
uses Launcher3's recents.
