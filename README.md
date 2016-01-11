iOS Blank App
=============
iOS Blank app is a simple app to get you started with FH iOS sdk.


You can scaffold this app either:
- using RHMAP (Red Hat Mobile Application Platform) UI console.
- or clone directly from this repository. If you clone it manually to make the app buildable in RHMAP Build Farm, replace the templaeing ```%id%``` in ```FHStarterProject\FHStarterProject-Info.plist``` in the following block:

```xml
<key>CFBundleIdentifier</key>
<string>%id%</string>
```