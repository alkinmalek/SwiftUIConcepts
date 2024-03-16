//
//  APICallWithPaginationPexel.swift
//  SwiftConceptsDemos
//
//  Created by ETechM23 on 08/03/24.
//

import SwiftUI
import SDWebImageSwiftUI

// MARK: - PexelsPaginationModel
struct PexelsPaginationModel: Codable {
    let page, perPage: Int?
    let photos: [PexelsPhoto]?
    let totalResults: Int?
    let nextPage, prevPage: String?

    enum CodingKeys: String, CodingKey {
        case page
        case perPage
        case photos
        case totalResults
        case nextPage
        case prevPage
    }
}

// MARK: - Photo
struct PexelsPhoto: Codable, Identifiable {
    let id, width, height: Int?
    let url: String?
    let photographer: String?
    let photographerURL: String?
    let photographerID: Int?
    let avgColor: String?
    let src: PexelsSrc?
    let liked: Bool?
    let alt: String?

    enum CodingKeys: String, CodingKey {
        case id, width, height, url, photographer
        case photographerURL
        case photographerID
        case avgColor
        case src, liked, alt
    }
}

// MARK: - Src
struct PexelsSrc: Codable {
    let original, large2X, large, medium: String?
    let small, portrait, landscape, tiny: String?

    enum CodingKeys: String, CodingKey {
        case original
        case large2X
        case large, medium, small, portrait, landscape, tiny
    }
}

// MARK: - ViewModel
class PexelsViewModel : ObservableObject {
    
    
    @Published var isLoading: Bool = false
//    @Published var items: [String]
    @Published var pexelsPaginationModel : [PexelsPaginationModel] = []
    @Published var pexelsPhoto: [PexelsPhoto] = []
    
    var totalPages = 50
    var per_page = 10
    var page : Int = 1
    var pexelsToken = "TTMYeFAslEs4K25CjHHGYcV7Qwguf4DFmttGs04WXq8bFvDVXbuhhISR"
    
    private var counter: Int = 1
    
    // Load more data
    func loadMoreContent()  {
        guard page <= totalPages else {
            print("Max page-\(totalPages) limit exceeds")
            return
        }
        if !self.isLoading {
            self.isLoading = true
             getPexelDatas()
        }
    }
    
//    //send a fake network request...
//    func sendFakeRequest() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            for _ in 1...10 {
//                self.items.append("item \(self.counter)")
//                self.counter += 1
//            }
//            self.isLoading = false
//        }
//    }
    
    //MARK: - API CALL
    func getPexelDatas()  {
        
        var request = URLRequest(url: URL(string: "https://api.pexels.com/v1/curated?page=\(page)&per_page=\(per_page)")!,timeoutInterval: Double.infinity)
        request.addValue(pexelsToken, forHTTPHeaderField: "Authorization")

        request.httpMethod = "GET"

         URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
//          print(String(data: data, encoding: .utf8)!)
            
             DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                 do {
                     let pData = try JSONDecoder().decode(PexelsPaginationModel.self, from: data)
                     self.pexelsPaginationModel.append(pData)
                     if let photos = pData.photos {
                         for photo in photos {
                                 self.pexelsPhoto.append(photo)
                         }
                     }
                     self.isLoading = false
                 } catch {
                     self.isLoading = false
                     print("Error fetching Pexels Data \(error)")
                 }
             }
         
        }.resume()

    }
    
}

struct APICallWithPaginationPexel: View {
    @StateObject var viewModel = PexelsViewModel()
    
    var body: some View {
        
        
        VStack {
            
            Text("Pexels API Pagination Demo")
                .font(.title3)
            
            ZStack {
                
                if viewModel.isLoading {
                    ProgressView().scaleEffect(5.0)
                        .progressViewStyle(.circular).tint(.cyan)
                        .zIndex(1)
                }
                
                List {
                    ForEach(viewModel.pexelsPhoto) { pexelphoto in
                        LazyVStack {
                            WebImage(url: URL(string:  pexelphoto.src?.medium ?? "https://images.unsplash.com/photo-1709418399429-c12dd9aa2a20?q=80&w=1964&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"))
                                .placeholder(content: {
                                    ProgressView().scaleEffect(2.0).tint(.cyan)
                                        .frame(maxWidth: .infinity)
                                })
                                .resizable()
                                .frame(maxWidth: .infinity)
                                .frame(height: 250)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .scaledToFit()
                            
                            Text("\(pexelphoto.photographer ?? "")")
                                .padding()
                        }
                        .onAppear {
                            if pexelphoto.id == viewModel.pexelsPhoto.last?.id {
                                viewModel.page += 1
                                viewModel.loadMoreContent()
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            viewModel.loadMoreContent()
        }
    }
}

#Preview {
    APICallWithPaginationPexel()
}
