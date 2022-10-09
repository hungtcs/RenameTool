//
//  ReplaceView.swift
//  RenameTool
//
//  Created by 鸿则 on 2022/10/8.
//

import SwiftUI
import Combine

struct SideView: View {

    var body: some View {
        TabView {
            ReplaceView()
            .tabItem {
                Text("替换")
            }
            
            OrderNumberView()
            .tabItem {
                Text("序号")
            }
        }
        .frame(width: 240)
        .padding(.top, 32)
        .background(BlurView())
        
    }

}

struct SideView_Previews: PreviewProvider {

    static var previews: some View {
        SideView()
    }

}
