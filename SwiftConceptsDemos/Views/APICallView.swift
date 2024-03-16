//
//  APICallView.swift
//  SwiftConceptsDemos
//
//  Created by ETechM23 on 08/03/24.
//

import SwiftUI
import SDWebImageSwiftUI

// MARK: - Error Enum
enum NetworkError: Error {
    case badUrl
    case invalidRequest
    case badResponse
    case badStatus
    case failedToDecodeResponse
}

enum APICallViewEnum: CaseIterable {
    case home
    case jsonPlaceHolder
    case fakeStore
}

// MARK: - Model
struct Post: Identifiable, Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

struct FakeStoreModel: Identifiable, Codable {
    let id: Int
    let title: String
    let price: Double
    let category: String
    let description: String
    let image: String
}

// MARK: - ViewModel
@MainActor class PostViewModel: ObservableObject {
    @Published var postData = [Post]()
    @Published var fakeStoreDatas = [FakeStoreModel]()
    @Published var selectedScreen: APICallViewEnum = .home
    @Published var isLoading: Bool = false
    
    func fetchJSONPlaceholderData() async {
        isLoading = true
        guard let downloadedPosts: [Post] = await WebService().downloadData(fromURL: "https://jsonplaceholder.typicode.com/posts", header: nil, body: nil) else {
            isLoading = false
            return
        }
        isLoading = false
        postData = downloadedPosts
    }
    
    func fetchFakeStoreData() async {
        isLoading = true
        guard let downloadedFakeStore: [FakeStoreModel] = await WebService().downloadData(fromURL: "https://fakestoreapi.com/products", header: nil, body: nil) else {
            isLoading = false
            return
        }
        isLoading = false
        fakeStoreDatas = downloadedFakeStore
    }
}

struct APICallView: View {
    @StateObject var vm = PostViewModel()

    
    var body: some View {
        
        ZStack {
            switch vm.selectedScreen {
            case .home:
                Home()
            case .jsonPlaceHolder:
                    JSONPlaceholderAPI()
            case .fakeStore:
                fakeStoreAPI()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    
    }
}

extension APICallView {
    
    @ViewBuilder
    func Home() -> some View {
            VStack(spacing: 20) {
               
                Button("JSONPlaceholder API") {
                    withAnimation(.snappy()) {
                        vm.selectedScreen = .jsonPlaceHolder
                    }
                }
                
                Button("FakeStore API") {
                    withAnimation(.snappy()) {
                        vm.selectedScreen = .fakeStore
                    }
                }

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
     
    }
    
    @ViewBuilder
    func JSONPlaceholderAPI() -> some View {
        VStack {
            Text("JSONPlaceholder API")
                .font(.title3)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Button("Back") {
                        withAnimation(.snappy()) {
                            vm.selectedScreen = .home
                        }
                    }
                    .padding()
                }

            if vm.isLoading {
                ProgressView().scaleEffect(2.0)
                    .progressViewStyle(.circular)
                    .frame(maxHeight: .infinity)
            } else {
                List(vm.postData) { post in
                    HStack {
                        Text("\(post.userId)")
                            .padding()
                            .overlay(Circle().stroke(.blue))
                        
                        VStack(alignment: .leading) {
                            Text(post.title)
                                .bold()
                                .lineLimit(1)
                            
                            Text(post.body)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onAppear {
            if vm.postData.isEmpty {
                Task {
                    await vm.fetchJSONPlaceholderData()
                }
            }
        }
    }
    
    @ViewBuilder
    func fakeStoreAPI() -> some View {
        VStack {
            Text("Fake Store API")
                .font(.title3)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Button("Back") {
                        withAnimation(.snappy()) {
                            vm.selectedScreen = .home
                        }
                    }
                    .padding()
                }
            
            
            if vm.isLoading {
                ProgressView().scaleEffect(2.0)
                    .progressViewStyle(.circular)
                    .frame(maxHeight: .infinity)
            } else {
                List(vm.fakeStoreDatas) { fakeData in
                    
                    
                    HStack {
                        
                        WebImage(url: URL(string: fakeData.image))
                            .placeholder(content: {
                                ProgressView {
                                    Text("Loading...")
                                }
                            })
                            .resizable()
                            .frame(width: 80, height: 80)
                            .scaledToFill()
                        
                        VStack(alignment: .leading) {
                            Text(fakeData.title)
                                .bold()
                                .lineLimit(1)
                            
                            Text(fakeData.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onAppear {
            if vm.fakeStoreDatas.isEmpty {
                Task {
                    await vm.fetchFakeStoreData()
                }
            }

        }
    }
    
}

#Preview {
    APICallView()
}
