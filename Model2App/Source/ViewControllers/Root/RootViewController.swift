//
//  RootViewController.swift
//  Model2App
//
//  Created by Karol Kulesza on 6/19/18.
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

import UIKit


/**
 *  Root menu view controller responsible for presenting a collection view of all model classes shown as menu items,
 *  with the option to show a list of objects of a given model class, by tapping on a selected class / menu item
 */
open class RootViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, BasePresenter {
    
    // MARK: -
    // MARK: Properties & Constants
    
    public private(set) var classes = [ModelClass.Type]()
    private let cellReuseIdentifier = "RootCollectionViewCell"
    private let transitionDelegate = TransitioningDelegate()
    
    // MARK: -
    // MARK: UIViewController Methods
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = M2A.config.menuDefaultBackgroundImageName == M2AConstants.menuBackgroundImageName ? ModelManager.shared.bundle : Bundle.main
        let backgroundImage = UIImage.init(named: M2A.config.menuDefaultBackgroundImageName, in: bundle, compatibleWith: nil)
        collectionView?.backgroundView = UIImageView(image: backgroundImage)
        collectionView?.register(RootViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView?.contentInsetAdjustmentBehavior = .always
        
        classes = ModelManager.shared.allRootClasses
    }
    
    // MARK: -
    // MARK: UICollectionViewDataSource Methods
    
    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return classes.count
    }
    
    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let modelClass: ModelClass.Type = classes[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! RootViewCell
        let cellSize = getCellSizeForCollectionSize(size: collectionView.bounds.size)
        cell.updateForCellSize(cellSize)
        cell.updateForClass(modelClass)
        
        return cell
    }
    
    // MARK: -
    // MARK: UICollectionViewDelegateFlowLayout Methods
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return getCellSizeForCollectionSize(size: collectionView.bounds.size)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let inset = M2A.config.menuDefaultInset
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return M2A.config.menuDefaultMinimumLineSpacing
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return M2A.config.menuDefaultMinimumInteritemSpacing
    }
    
    // MARK: -
    // MARK: UICollectionViewDelegate Methods
    
    override open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let itemAttributes = collectionView.layoutAttributesForItem(at: indexPath)
        let itemFrame = itemAttributes?.frame
        transitionDelegate.initialFrame = collectionView.convert(itemFrame!, to: collectionView.superview)
        
        showObjectListVCForClass(classes[indexPath.row])
    }
    
    // MARK: -
    // MARK: UIContentContainer Methods
    
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if let collectionView = collectionView {
            collectionView.collectionViewLayout.invalidateLayout()
            
            coordinator.animate(alongsideTransition: { (context) in
                let cellSize = self.getCellSizeForCollectionSize(size: size)
                collectionView.visibleCells.forEach { cell in
                    (cell as? RootViewCell).flatMap { $0.updateForCellSize(cellSize) }
                }
            }, completion: nil)
        }
    }
    
    // MARK: -
    // MARK: RootViewController Methods
    
    func showObjectListVCForClass(_ modelClass: ModelClass.Type, presenter: BasePresenter? = nil) {
        let presenter = presenter ?? self
        
        let objectListVC = ObjectListViewController(objectClass: modelClass)
        let navigationVC = UINavigationController(rootViewController: objectListVC)
        navigationVC.transitioningDelegate = transitionDelegate
        navigationVC.modalPresentationStyle = .custom
        presenter.present(navigationVC, animated: true, completion: nil)
    }
    
    // MARK: -
    // MARK: Helper Methods
    
    private func getCellSizeForCollectionSize(size: CGSize) -> CGSize {
        let numberOfColumns = M2A.config.menuDefaultNumberOfColumns
        let iteritemSpacing = M2A.config.menuDefaultMinimumInteritemSpacing
        let insetsAndSpacings = 2 * M2A.config.menuDefaultInset + collectionView!.safeAreaInsets.left + collectionView!.safeAreaInsets.right + iteritemSpacing * CGFloat(numberOfColumns - 1)
        let itemWidth = ((size.width - insetsAndSpacings) / CGFloat(numberOfColumns)).rounded(.down)

        return CGSize(width: itemWidth, height: itemWidth)
    }
    
}

