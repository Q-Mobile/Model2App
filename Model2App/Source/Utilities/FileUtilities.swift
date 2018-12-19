//
//  FileUtilities.swift
//  Model2App
//
//  Created by Karol Kulesza on 4/25/18.
//  Copyright © 2018 Q Mobile { http://Q-Mobile.IT } 
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import UIKit


class FileUtilities {
    
    class func getRandomMenuIcon() -> String {
        let bundleURL = ModelManager.shared.bundle.bundleURL
        let menuIconsURL = bundleURL.appendingPathComponent("MenuIcons.bundle")
        let menuIcons = try! FileManager.default.contentsOfDirectory(at: menuIconsURL, includingPropertiesForKeys: [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey], options: .skipsHiddenFiles)
        
        let randomIndex = Int(arc4random_uniform(UInt32(menuIcons.count)))
        return menuIcons[randomIndex].lastPathComponent
    }

    class func getImageDirectory() -> URL {
        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imageDir = documentsDir.appendingPathComponent("M2A_Images")
        do { try FileManager.default.createDirectory(at: imageDir, withIntermediateDirectories: true, attributes: nil) } catch {
            log_error("Error creating images directory: \(error.localizedDescription) ...")
        }
        
        return imageDir
    }
    
}
