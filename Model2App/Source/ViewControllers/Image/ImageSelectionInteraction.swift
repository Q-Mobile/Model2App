//
//  ImageSelectionInteraction.swift
//  Model2App
//
//  Created by Karol Kulesza on 9/26/18.
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


class ImageSelectionInteraction {

    // MARK: -
    // MARK: Properties & Constants
    
    private var imageNameData: Data?
    private var imageSelected: ((UIImage?) -> Void)?
    private var cancelled: (() -> Void)?
    private weak var presenter: BasePresenter?
    
    // MARK: -
    // MARK: Initializers & Deinitializers
    
    init(presenter: BasePresenter,
                imageNameData: Data?,
                imageSelected: @escaping (UIImage?) -> Void,
                cancelled: @escaping () -> Void) {
        self.imageNameData = imageNameData
        self.imageSelected = imageSelected
        self.cancelled = cancelled
        self.presenter = presenter
    }
    
    // MARK: -
    // MARK: ImageSelectionInteraction Methods
    
    func handle(sourceView: UIView?) {
        let actions = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
        createImageSourceAction(for: .savedPhotosAlbum, withTitle: "Saved Photos Album", imageSelected).flatMap { actions.addAction($0) }
        createImageSourceAction(for: .photoLibrary, withTitle: "Photo Library", imageSelected).flatMap { actions.addAction($0) }
        createImageSourceAction(for: .camera, withTitle: "Camera", imageSelected).flatMap { actions.addAction($0) }
        
        imageNameData.flatMap { imageNameData in
            let showImageAction = UIAlertAction(title: "Show Image", style: .default, handler: { [weak self] _ in
                guard let selfie = self, let image = ImageUtilities.getImageForNameData(nameData: imageNameData) else { return }
                let imageVC = ImageViewController(image: image)
                selfie.presenter?.present(imageVC, animated: true, completion: nil)
                selfie.cancelled?()
            })
            actions.addAction(showImageAction)
            
            let clearAction = UIAlertAction(title: "Clear Image", style: .destructive, handler: { [weak self] _ in
                self.flatMap { selfie in selfie.imageSelected?(nil) }
            })
            actions.addAction(clearAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
            self.flatMap { selfie in selfie.cancelled?() }
        })
        actions.addAction(cancelAction)
        sourceView.flatMap { view in
            actions.popoverPresentationController?.sourceView = view
            actions.popoverPresentationController?.sourceRect = view.bounds
        }

        self.presenter?.present(actions, animated: true, completion: nil)
    }
    
    // MARK: -
    // MARK: Helper Methods
    
    private func createImageSourceAction(for sourceType: UIImagePickerController.SourceType,
                                 withTitle title: String,
                                 _ imageSelectedClosure: ((UIImage?) -> Void)?) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return nil }
        
        let action = UIAlertAction(title: title, style: .default, handler: { [weak self] _ in
            self.flatMap { selfie in
                let imagePicker = ImagePickerController()
                imagePicker.sourceType = sourceType
                imagePicker.imageSelected = imageSelectedClosure
                
                selfie.presenter?.present(imagePicker, animated: true, completion: nil)
            }
        })
        return action
    }
    
}
