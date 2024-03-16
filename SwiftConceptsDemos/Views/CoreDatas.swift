//
//  CoreDatas.swift
//  SwiftConceptsDemos
//
//  Created by ETechM23 on 07/03/24.
//

import SwiftUI
import AlertToast

struct CoreDatas: View {
    @StateObject var dataManager = CoreDataManager()
    @State var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(dataManager.filterusersList) { user in
                    NavigationLink {
                        AddUSerView(user: user, isEdit: true)
                    } label: {
                        HStack {
                            Text(user.username)
                            Text(" - ")
                            Text(user.email)
                        }
                    }
                }
                .onDelete(perform: deleteUser)
            }
            .navigationTitle("Core Data")
            .searchable(text: $searchText)
            .onChange(of: searchText, {
                dataManager.filterUser(searchTxt: searchText)
            })
            .onChange(of: dataManager.sortDescriptor, {
                dataManager.sortUser()
            })
            .toolbar {
          
                
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Button("Name A-Z") {
                        dataManager.sortDescriptor = [NSSortDescriptor(key: "username", ascending: true)]
                    }
                    
                    Button("Name Z-A") {
                        dataManager.sortDescriptor = [NSSortDescriptor(key: "username", ascending: false)]
                    }
                    
                    Button("Email 📈") {
                        dataManager.sortDescriptor = [NSSortDescriptor(key: "email", ascending: true)]
                    }
                    
                    Button("Email 📉") {
                        dataManager.sortDescriptor = [NSSortDescriptor(key: "email", ascending: false)]
                    }
                }

                NavigationLink {
                    AddUSerView()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .environmentObject(dataManager)
    }
}

// MARK: - Fns
extension CoreDatas {
    func deleteUser(_ indexSet: IndexSet) {
        for index in indexSet {
            let user = dataManager.usersList[index]
            dataManager.deleteUser(user)
        }
    }
}

// MARK: - Add User View
struct AddUSerView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: CoreDataManager
    @State var user: UserModel = .init(srNoStr: "", email: "", password: "", username: "", createdAt: .now)
    @State var showToast: Bool = false
    @State var toastTile: String = ""
    @State var isEdit: Bool = false
    
    var body: some View {
        VStack {
        Form {
            TextField("Sr No", text: $user.srNoStr)
                .keyboardType(.numberPad)
            TextField("Email", text: $user.email)
            TextField("Password", text: $user.password)
            TextField("Username", text: $user.username)
            
            Section("Created At") {
                DatePicker("Select Date", selection: $user.createdAt)
            }
            
        }
        .navigationTitle("Add User")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button(isEdit ? "Edit" : "Save") {
                saveUser()
            }
        }
        .toast(isPresenting: $showToast) {
            AlertToast(displayMode: .alert, type: .image("warning", .red), title: toastTile)
        }

    }
    }
    
    func saveUser() {
        if user.srNoStr.trimmingCharacters(in: .whitespacesAndNewlines).count < 1 {
            showToast(title: "Sr no cannot be empty")
        } else if !user.srNoStr.isNumber {
            showToast(title: "Sr no must be a number")
        } else if user.email.trimmingCharacters(in: .whitespacesAndNewlines).count < 1 {
            showToast(title: "Email cannot be empty")
        } else if user.password.trimmingCharacters(in: .whitespacesAndNewlines).count < 1 {
            showToast(title: "Password no cannot be empty")
        } else if user.username.trimmingCharacters(in: .whitespacesAndNewlines).count < 1 {
            showToast(title: "Username cannot be empty")
        } else {
            if isEdit {
                dataManager.editUser(user)
            } else {
                dataManager.addUser(user: user)
            }
            dismiss()
        }
    }
    
    func showToast(title: String) {
        toastTile = title
        showToast = true
    }
}


#Preview {
    CoreDatas()
}
