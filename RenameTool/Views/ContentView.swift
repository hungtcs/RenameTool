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
    @State private var sortOrder = [KeyPathComparator(\URL.lastPathComponent)]
    @StateObject var openedFiles = OpenedFiles()
    
    var body: some View {
        HStack(spacing: 0) {
            SideView()

            VStack(spacing: 0) {
                HStack {
                    if openedFiles.fileURLs.count > 0 {
                        if openedFiles.selectedFiles.count > 0 {
                            Text("已添加 \(openedFiles.fileURLs.count) 个文件（已选 \(openedFiles.selectedFiles.count) 个）")
                        } else {
                            Text("已添加 \(openedFiles.fileURLs.count) 个文件")
                        }
                    } else {
                        Text("点击右侧加号选择文件")
                    }
                    Spacer()
                    Button(
                        action: {
                            openedFiles.fileURLs = openedFiles.fileURLs.filter { url in
                                !openedFiles.selectedFiles.contains(url)
                            }
                            openedFiles.selectedFiles.removeAll()
                        },
                        label: {
                            Image(systemName: "minus")
                            Text("移除已选文件")
                        }
                    )
                    .help(LocalizedStringKey("移除所选项目"))
                    .disabled(openedFiles.selectedFiles.count < 1)
                    Button(
                        action: {
                            openedFiles.fileURLs = [];
                            openedFiles.selectedFiles.removeAll()
                        },
                        label: {
                            Image(systemName: "trash")
                            Text("移除全部文件")
                        }
                    )
                    .help(LocalizedStringKey("移除所选项目"))
                    .disabled(openedFiles.fileURLs.count < 1)
                    Button(
                        action: {
                            openedFiles.selectedFiles.removeAll()
                            let openPanel = NSOpenPanel()
                            openPanel.allowsMultipleSelection = true
                            openPanel.canChooseDirectories = false
                            
                            
                            openPanel.begin { response in
                                if response == .OK {
                                    openedFiles.fileURLs = openPanel.urls
                                    openedFiles.newFileURLs = openedFiles.fileURLs
                                }
                            }
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
                    selection: $openedFiles.selectedFiles,
                    sortOrder: $sortOrder,
                    columns: {
                        TableColumn("修改前", value: \.lastPathComponent)
                        TableColumn("修改后", value: \.lastPathComponent) { url in
                            let index = openedFiles.fileURLs.firstIndex(of: url)!
                            let newURL = openedFiles.newFileURLs[index]
                            Text(newURL.lastPathComponent)
                        }
                    },
                    rows: {
                        ForEach(openedFiles.fileURLs) { url in
                            TableRow(url)
                        }
                    }
                )
                .onChange(of: sortOrder) {
                    openedFiles.fileURLs.sort(using: $0)
                    openedFiles.newFileURLs.sort(using: $0)
                }
            }.frame(minWidth: 480)
        }
        .frame(minHeight: 400)
        .ignoresSafeArea(.all, edges: .all)
        .environmentObject(openedFiles)
    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
