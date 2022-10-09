//
//  OrderNumberView.swift
//  RenameTool
//
//  Created by 鸿则 on 2022/10/9.
//

import SwiftUI

struct OrderNumberView: View {
    @State private var applyError: Error?
    @State private var formatValue = "%02d - "
    @State private var position = "before"
    @State private var startWithZero = false
    @EnvironmentObject private var openedFiles: OpenedFiles
    
    private let fileManager = FileManager.default
    
    var body: some View {
        Form {
            HStack {
                TextField(text: $formatValue, label: {
                    Text("格式:")
                })
                .onChange(of: formatValue) { _ in
                    onValueChange()
                }
            }
            HStack {
                Picker(selection: $position, label: Text("位置:")) {
                    Text("之前").tag("before")
                    Text("之后").tag("after")
                }
                .onChange(of: position) { _ in
                    onValueChange()
                }
            }
            HStack {
                Toggle(isOn: $startWithZero) {
                    Text("从零开始")
                }
                .onChange(of: startWithZero) { _ in
                    onValueChange()
                }
            }
            
            HStack {
                Spacer()
                Button {
                    openedFiles.selectedFiles.removeAll()
                    for index in 0..<openedFiles.fileURLs.count {
                        let url: URL = openedFiles.fileURLs[index]
                        let newURL = openedFiles.newFileURLs[index]
                        do {
                            try fileManager.moveItem(at: url, to: newURL)
                            openedFiles.fileURLs[index] = newURL
                        } catch let error {
                            applyError = error
                            dump(error)
                        }
                    }
                } label: {
                    Text("应用")
                }
            }
            
            Spacer()
        }
        .onAppear(perform: {
            onValueChange()
        })
        .onChange(of: openedFiles.fileURLs, perform: { newValue in
            onValueChange()
        })
        .padding(12)
        .alert(
            isPresented: Binding(
                get: {
                    return self.applyError != nil
                },
                set: { _ in
                    self.applyError = nil
                }
            )
        ) {
            Alert(
                title: Text("错误"),
                message: Text(applyError?.localizedDescription ?? "错误")
            )
        }
    }
    
    private func onValueChange() {
        openedFiles.fileURLs.forEach { url in
            let newFileName = getNewFileName(url: url)
            let newURL = URL(string: url.absoluteString)?
                .deletingLastPathComponent()
                .appendingPathComponent(newFileName)
            if newURL != nil {
                let index = openedFiles.fileURLs.firstIndex(of: url)!
                openedFiles .newFileURLs[index] = newURL!
            }
        }
    }
    
    private func getNewFileName(url: URL) -> String {
        let fileName = url.lastPathComponent
        
        var index = openedFiles.fileURLs.firstIndex(of: url)!
        
        if !startWithZero {
            index += 1
        }
        
        switch position {
            case "before": do {
                return "\(String(format: formatValue, index))\(fileName)"
            }
            case "after": do {
                return "\(fileName)\(String(format: formatValue, index))"
            }
            default:
                return fileName
        }
        
        
    }
}

struct OrderNumberView_Previews: PreviewProvider {
    static var previews: some View {
        OrderNumberView()
    }
}
