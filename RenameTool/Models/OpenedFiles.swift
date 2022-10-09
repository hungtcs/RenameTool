//
//  OpenedFiles.swift
//  RenameTool
//
//  Created by 鸿则 on 2022/10/9.
//

import Foundation

class OpenedFiles: ObservableObject {
    @Published var fileURLs: [URL] = []
    @Published var newFileURLs: [URL] = []
    @Published var selectedFiles = Set<URL>()
}
