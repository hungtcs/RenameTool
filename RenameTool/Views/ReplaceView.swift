//
//  ReplaceView.swift
//  RenameTool
//
//  Created by 鸿则 on 2022/10/8.
//

import SwiftUI
import Combine

struct ReplaceView: View {
    @Binding var findValue: String
    @Binding var replaceWithValue: String
    
    var onApply: (() -> Void)?
    
    var body: some View {
        VStack {
            Form {
                TextField("查找：", text: $findValue)
                TextField("替换为：", text: $replaceWithValue)
            }
            .labelStyle(IconOnlyLabelStyle())
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 6).stroke(.gray, lineWidth: 2))
            
            Spacer()
            HStack {
                Spacer()
                Button {
                    onApply?()
                } label: {
                    Text("应用")
                }

            }
        }
        .frame(width: 240)
        .padding()
        .padding(.top)
        .background(BlurView())
    }
}

//struct ReplaceView_Previews: PreviewProvider {
//
//
////    static var previews: some View {
//////        ReplaceView(
//////            findValue: "", replaceWithValue: <#T##Binding<String>#>
//////        )
////    }
//}
