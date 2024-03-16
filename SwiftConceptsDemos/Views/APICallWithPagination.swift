//
//  APICallWithPagination.swift
//  SwiftConceptsDemos
//
//  Created by ETechM23 on 08/03/24.
//

import SwiftUI
import Alamofire

// MARK: - Model
struct ReqResUsers : Decodable{
    let page : Int
    let perPage : Int
    let total: Int
    let totalPages : Int
    let data : [ReqResUser]
}

struct ReqResUser : Decodable, Hashable{
    let id : Int
    let email : String
    let firstName : String
    let lastName : String
    let avatar : URL
}

// MARK: - ViewModel
class ReqResUsersViewModel : ObservableObject {
    
    //MARK: - Properties
    @Published var users : [ReqResUser] = []
    
    var totalPages = 0
    var page : Int = 1
    
    init() {
        getUsers()
    }
    
    //MARK: - PAGINATION
    func loadMoreContent(currentItem item: ReqResUser){
        let thresholdIndex = self.users.index(self.users.endIndex, offsetBy: -1)
        print("Load threshold: \(thresholdIndex), ItemID: \(item.id), page+1: \(page + 1), TotalPages: \(totalPages)")
        if thresholdIndex == item.id, (page + 1) <= totalPages {
            page += 1
            getUsers()
        }
    }
    
    //MARK: - API CALL
    func getUsers(){
        
        let apiUrl = "https://reqres.in/api/users?page=\(page)"
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        AF.request(apiUrl).responseDecodable(of: ReqResUsers.self, decoder: decoder) { [weak self] (response) in
            switch response.result{
                case .success(let users):
                    self?.totalPages = users.totalPages
                    self?.users.append(contentsOf: users.data)
                case .failure(let afError):
                    print("Error : \(afError)")
                //Handle error
            }
        }
    }
    
}

// MARK: - View
struct APICallWithPagination: View {
    
    //MARK:- PROPERTIES
    @StateObject var usersVM = ReqResUsersViewModel()
    
    //MARK:- BODY
    var body: some View {
        NavigationView{
            ScrollView {
                LazyVStack {
                    ForEach(usersVM.users, id: \.self) { user in
                        UserView(user: user)
                            .onAppear(){
                                usersVM.loadMoreContent(currentItem: user)
                            }
                    }
                }
            }
            .navigationTitle("Users")
            
        }
    }
}

// MARK: - ReqRes User
struct UserView: View {
    //MARK: - PROPERTIES
    var user : ReqResUser
    
    //MARK: - BODY
    var body: some View {
        HStack(alignment: .center, spacing: nil, content: {
            //Image
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80.0, height: 80.0, alignment: .center)
                .foregroundColor(.orange)
                .padding(.all, 20)
            
            VStack(alignment: .leading, spacing: 5, content: {
                HStack{
                    Text("First Name :")
                        .fontWeight(.semibold)
                    Text("\(user.firstName)")
                }
                
                HStack{
                    Text("Last Name :")
                        .fontWeight(.semibold)
                        .bold()
                    Text("\(user.lastName)")
                }
                
                HStack{
                    Text("Email :")
                        .fontWeight(.semibold)
                    Text("\(user.email)")
                }
                
            })
            .foregroundColor(.white)
        })
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
        .background(Color.black)
        .cornerRadius(10.0)
        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 0)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
    }
}


#Preview {
    APICallWithPagination()
}
