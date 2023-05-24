//
//  ArrowWindow.swift
//  
//
//  Created by Adam on 23/05/2023.
//

import Cocoa
import SwiftUI

public class ArrowWindow: NSWindow {
    public convenience init(arrowSize: NSSize, statusItem: NSStatusItem) {
        let vc = NSHostingController(
            rootView: ArrowView()
                .shadow(color: .black.opacity(0.25), radius: arrowSize.width * 0.3, x: 0, y: arrowSize.width * 0.2)
                .frame(width: arrowSize.width, height: arrowSize.height)
                .padding(arrowSize.width)
        )
        vc.view.wantsLayer = true

        if #available(macOS 13.0, *) {
            vc.sizingOptions = [.preferredContentSize]
        }
        self.init(contentViewController: vc)
        styleMask = [.borderless]
        isMovableByWindowBackground = false
        isMovable = false
        acceptsMouseMovedEvents = false
        isOpaque = false
        titleVisibility = .hidden
        backgroundColor = .clear
        canHide = false
        isReleasedWhenClosed = false
        hasShadow = false
        level = .statusBar
        collectionBehavior = [.canJoinAllSpaces, .ignoresCycle, .fullScreenNone, .stationary]
        isExcludedFromWindowsMenu = true
        if let button = statusItem.button, let window = button.window {
            setFrameOrigin(NSPoint(x: window.frame.maxX - arrowSize.width * 2, y: window.frame.minY + arrowSize.width))
        }
    }

    public func show() {
        alphaValue = 0
        self.makeKeyAndOrderFront(nil)
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.4
            animator().alphaValue = 1
        }
    }
}
