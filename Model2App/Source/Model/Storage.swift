//
//  Storage.swift
//  Model2App
//
//  Created by Karol Kulesza on 9/29/18.
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
import RealmSwift


/**
 *  `Objects` is an auto-updated list of objects of a given `ModelClass` subclass
 */
public typealias Objects = Results<ModelClass>

/**
 *  `ObjectProperty` describes one property of a given `ModelClass` subclass
 */
public typealias ObjectProperty = Property

/**
 *  `OptionalProperty` represents an optional value for types that can't be
 *  directly declared as `@objc` in Swift, such as `Int`, `Float`, `Double`, and `Bool`.
 */
public typealias OptionalProperty = RealmOptional

typealias ObjectPropertyType = PropertyType
typealias ObjectNotification = NotificationToken
typealias CollectionChange = RealmCollectionChange

extension Results { var objectCount: Int { return count } }


/**
 *  Protocol implemented by `Storage` class
 */
public protocol StorageProtocol {
    /// Determines whether the data model / schema was changed, since the last storage access
    var isModelChanged: Bool { get }
    
    /// Determines whether the storage is currently in write transaction
    var isInWriteTransaction: Bool { get }
    
    /**
     *  Begin write transaction
     */
    func beginWrite()
    
    /**
     *  Commit write transaction
     */
    func commitWrite()
    
    /**
     *  Cancel write transaction
     */
    func cancelWrite()
    
    /**
     *  Execute a given block within a write transaction
     */
    func write(_ block: (() throws -> Void))
    
    /**
     *  Add or update a given object in storage
     */
    func add(_ object: ModelClass)
    
    /**
     *  Delete a given object from the storage
     */
    func delete(_ object: ModelClass)
    
    /**
     * Delete all objects from the storage
     */
    func deleteAll()
    
    /**
     *  Retrieves all objects of a given class from the storage
     */
    func objects<Element: ModelClass>(_ type: Element.Type) -> Results<Element>
    
    /**
     *  Retrieves the first object of a given class from the storage
     */
    func firstObject<Element: ModelClass>(_ type: Element.Type) -> Element?
}


class Storage : StorageProtocol {
    static let shared = Storage() ; private init() {} // SINGLETON
    
    private lazy var realm: Realm = {
        do { return try Realm() } catch {
            fatalError("Error initializing storage: \(error.localizedDescription) ...")
        }
    }()

    var url: URL? {
        return Realm.Configuration.defaultConfiguration.fileURL
    }

    var inMemoryId: String? {
        set {
            Realm.Configuration.defaultConfiguration.inMemoryIdentifier = newValue
        }
        get {
            return Realm.Configuration.defaultConfiguration.inMemoryIdentifier
        }
    }
    
    func printStoragePath() {
        guard let storageString = url?.absoluteString else { return }
        log("STORAGE PATH: \n\(storageString)")
    }
    
    // MARK: -
    // MARK: Properties & Constants
    
    var isModelChanged: Bool {
        do { let _ = try Realm() } catch Realm.Error.schemaMismatch {
            return true
        } catch {}
        return false
    }
    
    var isInWriteTransaction: Bool {
        return realm.isInWriteTransaction
    }
    
    func beginWrite() {
        realm.beginWrite()
    }
    
    func commitWrite() {
        do { try realm.commitWrite() } catch {
            log_error("Error committing to storage: \(error.localizedDescription) ...")
        }
    }
    
    func cancelWrite() {
        realm.cancelWrite()
    }
    
    func write(_ block: (() throws -> Void)) {
        do { try realm.write(block) } catch {
            log_error("Error writing to storage: \(error.localizedDescription) ...")
        }
    }
    
    func add(_ object: ModelClass) {
        realm.add(object, update: false)
    }
    
    func delete(_ object: ModelClass) {
        realm.delete(object)
    }
    
    func deleteAll() {
        realm.deleteAll()
    }
    
    func objects<Element: ModelClass>(_ type: Element.Type) -> Results<Element> {
        return realm.objects(type)
    }
    
    func firstObject<Element: ModelClass>(_ type: Element.Type) -> Element? {
        return objects(type).first
    }
    
}

public extension M2A {
    static var storage: StorageProtocol {
        return Storage.shared
    }
}
