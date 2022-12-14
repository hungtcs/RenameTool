//
//  ReplaceView.swift
//  RenameTool
//
//  Created by 鸿则 on 2022/10/9.
//

import SwiftUI

struct ReplaceView: View {
    @State private var findValue: String = ""
    @State private var applyError: Error?
    @State private var replaceWithValue: String = ""
    @EnvironmentObject private var openedFiles: OpenedFiles
    
    private let fileManager = FileManager.default

    var body: some View {
        Form {
            HStack {
                TextField("查找: ", text: $findValue)
                    .onChange(of: findValue) { _ in
                        onValueChange()
                    }
            }
            HStack {
                TextField("替换: ", text: $replaceWithValue)
                    .onChange(of: replaceWithValue) { _ in
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
        
        guard let regexp = try? NSRegularExpression(pattern: findValue) else {
            return fileName
        }
               
        let newFileName = regexp.stringByReplacingMatches(
            in: fileName,
            range: NSRange(
                location: 0,
                length: fileName.count
            ),
            withTemplate: replaceWithValue
        )
        return newFileName
    }
}


struct ReplaceView_Previews: PreviewProvider {
    static var previews: some View {
        ReplaceView()
    }
}
