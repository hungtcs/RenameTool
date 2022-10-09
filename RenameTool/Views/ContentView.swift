//
//  ContentView.swift
//  RenameTool
//
//  Created by 鸿则 on 2022/10/8.
//

import SwiftUI

extension URL: Identifiable {
    public var id: URL { self }
}

struct ContentView: View {
    private let fileManager = FileManager.default;
    @State private var openedFiles = [URL]();
    @State private var selectedFiles = Set<URL>()
    @State private var sortOrder = [KeyPathComparator(\URL.lastPathComponent)]
    
    @State private var findValue = ""
    @State private var replaceWithValue = ""
    
    var body: some View {
        HStack(spacing: 0) {
            ReplaceView(
                findValue: $findValue,
                replaceWithValue: $replaceWithValue
            ) {
                selectedFiles.removeAll()
                for index in 0..<openedFiles.count {
                    let url: URL = openedFiles[index]
                    let newFileName = getNewFileName(url: url)
                    let newURL = URL(string: newFileName, relativeTo: url)!
                    
                    do {
                        try fileManager.moveItem(at: url, to: newURL)
                        openedFiles[index] = newURL
                    } catch let error {
                        dump(error)
                    }

                }
                
//                let downloadsDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
//                let downloadsDirectoryWithFolder = downloadsDirectory.appendingPathComponent("FolderToCreate")
//                do {
//                    try fileManager.createDirectory(
//                        at: downloadsDirectoryWithFolder,
//                        withIntermediateDirectories: true,
//                        attributes: nil
//                    )
//                } catch let err {
//                    dump(err)
//                }
            }
            Divider()
            VStack(spacing: 0) {
                HStack {
                    if openedFiles.count > 0 {
                        if selectedFiles.count > 0 {
                            Text("已添加 \(openedFiles.count) 个文件（已选 \(selectedFiles.count) 个）")
                        } else {
                            Text("已添加 \(openedFiles.count) 个文件")
                        }
                    } else {
                        Text("点击右侧加号选择文件")
                    }
                    Spacer()
                    Button(
                        action: {
                            openedFiles = openedFiles.filter { url in
                                !selectedFiles.contains(url)
                            }
                            selectedFiles.removeAll()
                        },
                        label: {
                            Image(systemName: "minus")
                            Text("移除已选文件")
                        }
                    )
                    .help(LocalizedStringKey("移除所选项目"))
                    .disabled(selectedFiles.count < 1)
                    Button(
                        action: {
                            openedFiles = [];
                            selectedFiles.removeAll()
                        },
                        label: {
                            Image(systemName: "trash")
                            Text("移除全部文件")
                        }
                    )
                    .help(LocalizedStringKey("移除所选项目"))
                    .disabled(openedFiles.count < 1)
                    Button(
                        action: {
                            selectedFiles.removeAll()
                            let openPanel = NSOpenPanel()
                            openPanel.allowsMultipleSelection = true
                            openPanel.canChooseDirectories = false
                            
                            
                            openPanel.begin { response in
                                if response == .OK {
                                    self.openedFiles = openPanel.urls;
                                }
                            }
                            
                            
//                            if openPanel.runModal() == .OK {
//                                self.openedFiles = openPanel.urls;
//                            }
                        },
                        label: {
                            Image(systemName: "plus")
                            Text("添加文件")
                        }
                    )
                    .help(LocalizedStringKey("添加文件"))
                }
                .padding(.all, 12)
                Table(
                    selection: $selectedFiles,
                    sortOrder: $sortOrder,
                    columns: {
                        TableColumn("修改前", value: \.lastPathComponent)
                        TableColumn("修改后", value: \.lastPathComponent) { url in
                            Text(getNewFileName(url: url))
                        }
                    },
                    rows: {
                        ForEach(openedFiles) { url in
                            TableRow(url)
                        }
                    }
                )
                .onChange(of: sortOrder) {
                    openedFiles.sort(using: $0)
                }
            }.frame(minWidth: 480)
        }
        .frame(minHeight: 400)
        .ignoresSafeArea(.all, edges: .all)
    }
    
    func getNewFileName(url: URL) -> String {
        let fileName = url.lastPathComponent
        do {
            let regexp = try NSRegularExpression(pattern: findValue)
            let newFileName = regexp.stringByReplacingMatches(
                in: fileName,
                range: NSRange(
                    location: 0,
                    length: fileName.count
                ),
                withTemplate: replaceWithValue
            )
            return newFileName
        } catch let error {
            dump(error)
            return fileName
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
