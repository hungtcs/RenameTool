//
//  BlurView.swift
//  RenameTool
//
//  Created by 鸿则 on 2022/10/8.
//

import SwiftUI

struct BlurView: NSViewRepresentable {
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.blendingMode = .behindWindow
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        
    }
    
}
