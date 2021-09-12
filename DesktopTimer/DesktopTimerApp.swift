// Copyright 2021 Masayuki Ishikawa <masayuki.ishikawa@gmail.com>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import SwiftUI

@main
struct DesktopTimerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var inited = false

    func applicationWillUpdate(_ notification: Notification) {
        if inited == false && NSApp.mainWindow != nil {
            // Setup mainWindow

            // NOTE: To move the window by trackpad, alpha should be greater than 0.0
            NSApp.mainWindow?.backgroundColor = NSColor(white: 1, alpha: 0.1)

            NSApp.mainWindow?.level = .floating
            NSApp.mainWindow?.isOpaque = false
            NSApp.mainWindow?.isMovableByWindowBackground = true
            NSApp.mainWindow?.styleMask.remove(.closable)
            NSApp.mainWindow?.styleMask.remove(.miniaturizable)
            NSApp.mainWindow?.styleMask.remove(.resizable)
            NSApp.mainWindow?.hasShadow = false
            NSApp.mainWindow?.titleVisibility = .hidden
            NSApp.mainWindow?.titlebarAppearsTransparent = true

            // Disable View menu
            NSWindow.allowsAutomaticWindowTabbing = false
            inited = true;
            print("++++ finish setting up mainWindow")
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        // To be a single application
        return true
   }
}
