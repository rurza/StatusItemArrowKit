//
//  ArrowWindow.swift
//  
//
//  Created by Adam on 23/05/2023.
//

import Cocoa
import SwiftUI

public class ArrowWindow: NSWindow {
    private weak var statusItem: NSStatusItem?
    private let arrowSize: NSSize

    public init(arrowSize: NSSize, statusItem: NSStatusItem) {
        let vc = NSHostingController(
            rootView: ArrowView()
                .shadow(color: .black.opacity(0.25), radius: arrowSize.width * 0.3, x: 0, y: arrowSize.width * 0.2)
                .frame(width: arrowSize.width, height: arrowSize.height)
                .padding(arrowSize.width)
        )
        vc.view.wantsLayer = true
        self.arrowSize = arrowSize
        let contentRect = NSRect(origin: .zero, size: vc.view.fittingSize)
        super.init(contentRect: contentRect, styleMask: [.borderless], backing: .buffered, defer: false)
        self.contentViewController = vc
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
        self.statusItem = statusItem
        updateOrigin()
        if let window = statusItem.button?.window {
            NotificationCenter.default.addObserver(self, selector: #selector(statusItemWindowDidMove(_:)), name: NSWindow.didMoveNotification, object: window)
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

    func updateOrigin() {
        if let button = statusItem?.button, let window = button.window {
            // arrowSize.width * 1.5 because the width of the entire view is arrowSize.width * 3 (there is padding)
            let point = NSPoint(x: window.frame.midX - arrowSize.width * 1.5, y: window.frame.minY + arrowSize.width)
            animator().setFrameTopLeftPoint(point)
        }
    }

    @objc
    func statusItemWindowDidMove(_ note: Notification) {
        guard let window = note.object as? NSWindow, window === statusItem?.button?.window else { return }
        updateOrigin()
    }

    public override func close() {
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.4
            animator().alphaValue = 0
        } completionHandler: {
            super.close()
        }

    }
}
