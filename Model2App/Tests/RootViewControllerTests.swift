//
//  RootViewControllerTests.swift
//  Model2AppTests
//
//  Created by Karol Kulesza on 10/22/18.
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

import XCTest
@testable import Model2App


class RootViewControllerTests: XCTestCase {
    
    private var rootVC: RootViewController!
    
    override func setUp() {
        super.setUp()
        rootVC = RootViewController(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    override func tearDown() {
        rootVC = nil
        super.tearDown()
    }
    
    func testLoadingRootVC() {
        XCTAssertNotNil(rootVC.view)
        XCTAssertNotNil(rootVC.collectionView)
        XCTAssertNotNil(rootVC.collectionView?.backgroundView)
        
        let dequeuedCell = rootVC.collectionView?.dequeueReusableCell(withReuseIdentifier: "RootCollectionViewCell", for: IndexPath(row: 0, section: 0))
        guard let cell = dequeuedCell else { return XCTFail("dequeuedCell from `RootViewController` is nil.")}
        
        XCTAssertTrue(type(of: cell) == type(of: RootViewCell()))
        XCTAssertEqual(rootVC.classes.count, ModelManager.shared.allRootClasses.count)
    }
    
    func testRootVCCollectionView() {
        guard let collectionView = rootVC.collectionView else {
            return XCTFail("`collectionView` on `RootViewController` is nil.")
        }
        let collectionCount = rootVC.collectionView(collectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(collectionCount, ModelManager.shared.allRootClasses.count)
        
        let rootCell = rootVC.collectionView(collectionView, cellForItemAt: IndexPath(row: 0, section: 0)) as? RootViewCell
        XCTAssertNotNil(rootCell)
    }
    
    func testRootVCCollectionViewLayouting() {
        guard let collectionView = rootVC.collectionView else { return XCTFail() }
        let cellSize = rootVC.collectionView(collectionView, layout: rootVC.collectionViewLayout, sizeForItemAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(cellSize.width, 98)
        
        let sectInset = rootVC.collectionView(collectionView, layout: rootVC.collectionViewLayout, insetForSectionAt: 0)
        let inset = M2A.config.menuDefaultInset
        XCTAssertTrue(sectInset.top==inset && sectInset.bottom==inset && sectInset.left==inset && sectInset.right==inset)
        
        let sectLineSpacing = rootVC.collectionView(collectionView, layout: rootVC.collectionViewLayout, minimumLineSpacingForSectionAt: 0)
        XCTAssertEqual(sectLineSpacing, M2A.config.menuDefaultMinimumLineSpacing)
        
        let sectInteritemSpacing = rootVC.collectionView(collectionView, layout: rootVC.collectionViewLayout, minimumInteritemSpacingForSectionAt: 0)
        XCTAssertEqual(sectInteritemSpacing, M2A.config.menuDefaultMinimumInteritemSpacing)
    }
    
    func testRootViewCell() {
        guard let collectionView = rootVC.collectionView else { return XCTFail() }
        guard let rootCell = rootVC.collectionView(collectionView, cellForItemAt: IndexPath(row: 0, section: 0)) as? RootViewCell else { return XCTFail() }
        
        XCTAssertNotNil(rootCell.imageView.image)
        XCTAssertNotNil(rootCell.nameLabel.text)
        XCTAssertTrue(rootCell.imageView.isDescendant(of: rootCell.contentView))
        XCTAssertTrue(rootCell.nameLabel.isDescendant(of: rootCell.contentView))
        
        rootCell.updateForClass(M2A_TestCompany.self)
        XCTAssertNotNil(rootCell.imageView.image)
        XCTAssertEqual(rootCell.nameLabel.text, "Companies")
    }
    
    func testRootVCObjectListPresentation() {
        let fakePresenter = BasePresenterMock()
        rootVC.showObjectListVCForClass(M2A_TestPerson.self, presenter: fakePresenter)

        XCTAssertTrue(fakePresenter.didPresent)
        XCTAssertNotNil(fakePresenter.presentedVC)
        guard let presentedVC = fakePresenter.presentedVC else { return XCTFail() }
        let isObjectListVCPresented = presentedVC.children.contains(where: { type(of: $0) == ObjectListViewController.self })
        XCTAssertTrue(isObjectListVCPresented)
    }
    
}
