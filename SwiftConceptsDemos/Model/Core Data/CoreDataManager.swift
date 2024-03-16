//
//  CoreDataManager.swift
//  SwiftConceptsDemos
//
//  Created by ETechM23 on 07/03/24.
//

import SwiftUI
import CoreData
import Foundation

// MARK: - If want to use custom model in Core Data use Transformable Data Type

/// Main data manager for the app
class CoreDataManager: NSObject, ObservableObject {

    @Published var usersList: [UserModel] = [UserModel]()
    @Published var filterusersList: [UserModel] = [UserModel]()
    @Published var sortDescriptor: [NSSortDescriptor] = [NSSortDescriptor(key: "username", ascending: true)]

    /// Core Data container with the database model
    let container: NSPersistentContainer = NSPersistentContainer(name: "CoreDataCRUD")
    
    init(isPReview: Bool = false) {
        super.init()
        container.loadPersistentStores { _, _ in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
        fetchUsers()
    }
    
    /// Fetch all Users
    private func fetchUsers() {
        let fetchRequest: NSFetchRequest<UsersEntity> = UsersEntity.fetchRequest()
        fetchRequest.sortDescriptors = sortDescriptor
        if let results = try? container.viewContext.fetch(fetchRequest) {
            var users = [UserModel]()
            results.forEach { entity in
                users.append(.init(id: entity.id ?? UUID().uuidString,srNoStr: "\(entity.srNo)", email: entity.email ?? "", password: entity.password ?? "", username: entity.username ?? "", createdAt: entity.createdAt ?? .now))
            }
            DispatchQueue.main.async {
                self.usersList = users
                self.filterusersList = self.usersList
            }
        }
    }
    
    func filterUser(searchTxt: String) {
        guard !searchTxt.isEmpty else {
            self.filterusersList = self.usersList
            return
        }
        self.filterusersList = self.filterusersList.filter({ $0.username.localizedStandardContains(searchTxt) || $0.email.localizedStandardContains(searchTxt) })
//        let fetchRequest: NSFetchRequest<UsersEntity> = UsersEntity.fetchRequest()
//        fetchRequest.sortDescriptors = sortDescriptor
//        fetchRequest.predicate = NSPredicate(format: "username CONTAINS[cd] %@", searchTxt)
//        if let results = try? container.viewContext.fetch(fetchRequest) {
//            var users = [UserModel]()
//            results.forEach { entity in
//                users.append(.init(id: entity.id ?? UUID().uuidString,srNoStr: "\(entity.srNo)", email: entity.email ?? "", password: entity.password ?? "", username: entity.username ?? "", createdAt: entity.createdAt ?? .now))
//            }
//            DispatchQueue.main.async {
//                self.filterusersList = users
//            }
//        }
    }
    
    func sortUser() {
        fetchUsers()
    }
    
    
    /// Add User
    func addUser(user: UserModel) {
        let userEntity = UsersEntity(context: container.viewContext)
        userEntity.id = user.id
        userEntity.srNo = user.srNo
        userEntity.email = user.email
        userEntity.password = user.password
        userEntity.username = user.username
        userEntity.createdAt = user.createdAt
       
        saveUser()
    }
    
    /// Delete User
    func deleteUser(_ model: UserModel) {
        DispatchQueue.main.async {
            let fetchRequest: NSFetchRequest<UsersEntity> = UsersEntity.fetchRequest()
            fetchRequest.sortDescriptors = self.sortDescriptor
            fetchRequest.predicate = NSPredicate(format: "id == %@", model.id)
            if let foundMatch = try? self.container.viewContext.fetch(fetchRequest).first {
                self.container.viewContext.delete(foundMatch)
                self.saveUser()
            }
        }
    }
    
    func editUser(_ model: UserModel) {
        let fetchRequest: NSFetchRequest<UsersEntity> = UsersEntity.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id == %@", model.id)
        if let foundMatch = try? self.container.viewContext.fetch(fetchRequest).first(where: { $0.id == model.id}) {
            foundMatch.id = model.id
            foundMatch.srNo = model.srNo
            foundMatch.email = model.email
            foundMatch.password = model.password
            foundMatch.username = model.username
            foundMatch.createdAt = model.createdAt
            saveUser()
        }
    }
    
    func saveUser() {
        do {
            try container.viewContext.save()
            fetchUsers()
        } catch {
            print("Error saving Core Data \(error)")
        }
    }

}
