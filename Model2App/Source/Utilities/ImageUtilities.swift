//
//  ImageUtilities.swift
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


class ImageUtilities {
    
    // MARK: -
    // MARK: Private Methods
    
    private class func getImageForName(name: String?) -> UIImage? {
        return name.flatMap { imageName in
            let imagePath = FileUtilities.getImageDirectory().appendingPathComponent(imageName)
            return (try? Data(contentsOf: imagePath)).flatMap { UIImage(data: $0) }
        }
    }

    // MARK: -
    // MARK: ImageUtilities Methods
    
    class func getImageForNameData(nameData: Data?) -> UIImage? {
        return nameData.flatMap { String(data: $0, encoding: .utf8) }.flatMap { getImageForName(name: $0) }
    }
    
    class func getThumbnailForNameData(nameData: Data?) -> UIImage? {
        return nameData.flatMap { String(data: $0, encoding: .utf8) }.flatMap { getImageForName(name: "\($0)_thumb") }
    }
    
    class func createThumbnailDataForImageData(_ imageData: Data?) -> Data? {
        return imageData.flatMap {
            let options = [
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceThumbnailMaxPixelSize: M2A.config.imageThumbnailDefaultMaxPixelSize] as CFDictionary
            
            return CGImageSourceCreateWithData($0 as CFData, nil)
                .flatMap { CGImageSourceCreateThumbnailAtIndex($0, 0, options) }
                .flatMap { UIImage(cgImage: $0).pngData() }
        }
    }
}
