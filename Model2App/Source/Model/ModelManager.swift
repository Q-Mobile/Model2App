//
//  ModelManager.swift
//  Model2App
//
//  Created by Karol Kulesza on 6/28/18.
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


protocol Application : class { var window: Window? { get } }
protocol Window : class { var rootViewController: UIViewController? { get set } }

extension UIApplication : Application { var window: Window? { get { return self.keyWindow } } }
extension UIWindow : Window {}


/**
 *  Class responsible for managing the model: dynamically loading model, cell and config classes,
 *  as well as loading & setting root view controller which displays a list of all classes acting as menu items
 */
public class ModelManager : NSObject {
    
    // MARK: -
    // MARK: Properties & Constants
    
    @objc public static let shared = ModelManager() ; private override init() {} // SINGLETON
    @objc public private(set) var isUnderTests = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil // Required for model loading logic

    /// List of all model classes defined by the app
    public private(set) var allModelClasses = [ModelClass.Type]()
    
    /// List of all available custom cell classes
    public private(set) var allCellClasses = [BaseCell.Type]()
    
    /// Configuration class, default one or custom one, if defined by the app
    public private(set) var configClass = M2AConfig.self
    
    internal private(set) var bundle = Bundle(for: ModelManager.self)
    
    // MARK: -
    // MARK: Launch & Load
    
    @objc public func invokeLauncher() {
        launch()
    }
    
    func launch(for app: Application? = UIApplication.shared) {
        guard allCellClasses.isEmpty else { return }
        guard let _ = app?.window else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { self.launch() } // In case main window is not available yet.
            return
        }
        if Storage.shared.isModelChanged {
            let migrationMessage = "There has been a data model change. Aborting launch, as model migrations are not yet supported by Model2App. Please remove the app and try again."
            log_error(migrationMessage)
            UIUtilities.showAlert(title: "Info", message: migrationMessage, okHandler: { exit(1) })
            return
        }
        loadAllClasses()
        if !validateAllModelClasses() {
            UIUtilities.showAlert(title: "Info", message: "Not all of the classes are valid. Please refer to the console logs for details.", okHandler: { exit(1) })
        }
        loadRoot(for: app)
    }
    
    private func loadRoot(for app: Application?) {
        app?.window.flatMap { window in
            let rootVC = M2A.config.defaultRootVC
            rootVC.view.layoutIfNeeded()
            
            let setWindowRootVC = { window.rootViewController = rootVC }
            if let windowView = window as? UIView {
                UIView.transition(with: windowView, duration: M2A.config.defaultPresentationAnimationDuration, options: .transitionCrossDissolve, animations: {
                    setWindowRootVC()
                })
            } else { setWindowRootVC() }
            
            log_debug("Finished setting root VC ...")
            Storage.shared.printStoragePath()
        }
    }
    
    private func loadAllClasses() {
        log("Inspecting all classes ...")
        var count = UInt32(0)
        let classList = objc_copyClassList(&count)!

        let modelClassName = String(describing: ModelClass.self)
        let baseCellName = String(describing: BaseCell.self)
        let configClassName = String(describing: M2AConfig.self)
        var configClasses = [M2AConfig.Type]()
        
        for i in 0..<Int(count) {
            let className = String(cString: class_getName(classList[i]))
            guard className.components(separatedBy: ".").count > 1 else { continue }

            if classList[i] is ModelClass.Type {
                guard (Bundle(for: classList[i]) == Bundle.main || isUnderTests) && !className.contains(modelClassName) else { continue }
                allModelClasses.append(classList[i] as! ModelClass.Type)
            } else if classList[i] is BaseCell.Type {
                guard !className.contains(baseCellName) else { continue }
                allCellClasses.append(classList[i] as! BaseCell.Type)
            } else if classList[i] is M2AConfig.Type {
                guard (Bundle(for: classList[i]) == Bundle.main || isUnderTests) && !className.contains(configClassName) else { continue }
                configClasses.append(classList[i] as! M2AConfig.Type)
            }
        }
        loadConfigClass(configClasses)
        allModelClasses.sort(by: { $0.menuOrder < $1.menuOrder })
        log("Finished inspecting all classes ...; Found \(allModelClasses.count) model classes.")
    }
    
    private func loadConfigClass(_ configClasses: [M2AConfig.Type]) {
        if configClasses.count > 1 {
            let warningMessage = "There is more than one `M2AConfig` subclass defined. Taking into consideration only \(configClasses[0]) class ..."
            log_error(warningMessage, log: Log.validation)
            UIUtilities.showAlert(title: "Warning", message: warningMessage)
        }
        guard !configClasses.isEmpty else {
            log("Did not find any `M2AConfig` subclass defined in the app; Using default app configuration ...")
            return
        }
        configClass = configClasses[0]
    }

    // MARK: -
    // MARK: Computed Properties
    
    var allRootClasses: [ModelClass.Type] {
        return allModelClasses.filter { !$0.isHiddenInRootView }
    }
    
    // MARK: -
    // MARK: Validation
    
    private func validateAllModelClasses() -> Bool {
        log("Validating model classes ...", log: Log.validation)
        var allClassesValid = true
        allModelClasses.forEach { modelClass in
            if !ModelValidator.shared.validate(objectClass: modelClass) { allClassesValid = false }
        }
        log("Finished validating model classes.", log: Log.validation)
        return allClassesValid
    }
    
    // MARK: -
    // MARK: Helper Methods
    
    private func printAllModelClasses() {
        for projectClass in allModelClasses {
            let cName = class_getName(projectClass)
            log_debug("Class: \(String(cString: cName))")
        }
    }
    
 }
