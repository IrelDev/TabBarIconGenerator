//
//  Presenter.swift
//  TabBarIconGenerator
//
//  Created by Kirill Pustovalov on 27.07.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

import AppKit

class Presenter {
    static public let shared = Presenter()
    
    private init() { }
    
    func presentNSOpenPanelForImage(completion: @escaping (_ result: Result<ImageModel, Error>) -> ()) {
        let panel = NSOpenPanel()
        
        panel.allowsMultipleSelection = false
        
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowedFileTypes = ["png", "jpg", "jpeg"]
        panel.canChooseFiles = true
        panel.title = "Select image"
        
        panel.begin { (result) in
            if result == .OK,
                let url = panel.urls.first,
                let image = NSImage(contentsOf: url) {
                let imageName = url.lastPathComponent
                
                completion(.success(ImageModel(imageName: imageName, image: image)))
            } else {
                completion(.failure(NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotOpenFile, userInfo: nil)))
            }
            
        }
    }
    func presentNSOpenPanelForFolder(completion: @escaping (_ result: Result<URL, Error>) -> ()) {
        let panel = NSOpenPanel()
        
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = true
        panel.title = "Select folder"
        
        panel.begin { (result) in
            if result == .OK, let url = panel.urls.first {
                completion(.success(url))
            } else {
                completion(.failure(NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotOpenFile, userInfo: nil)))
            }
        }
    }
    func createFolderAtPath(at path: URL, with name: String) {
        let folderPath = path.appendingPathComponent("\(name).imageset")
        var normalizedFolderPath = folderPath.absoluteString
        
        let prefix = "file://"
        
        normalizedFolderPath = normalizedFolderPath.replacingOccurrences(of: prefix, with: "")
        normalizedFolderPath = normalizedFolderPath.removingPercentEncoding ?? "\(normalizedFolderPath)"
        
        if !FileManager.default.fileExists(atPath: normalizedFolderPath) {
            do {
                try FileManager.default.createDirectory(atPath: normalizedFolderPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription);
            }
        }
    }
}
