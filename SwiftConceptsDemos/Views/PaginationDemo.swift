//
//  PaginationDemo.swift
//  SwiftConceptsDemos
//
//  Created by ETechM23 on 08/03/24.
//

import SwiftUI

// MARK: - View Model
final class PaginationDemoViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var items: [String]
    
    private var counter: Int = 1
    
    init() {
        items = []
        for i in 1...15 {
            items.append("item \(i)")
            counter += 1
        }
    }
    
    // Load more data
    func loadMoreContent() {
        if !self.isLoading {
            self.isLoading = true
            sendFakeRequest()
        }
    }
    
    //send a fake network request...
    func sendFakeRequest() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            for _ in 1...10 {
                self.items.append("item \(self.counter)")
                self.counter += 1
            }
            self.isLoading = false
        }
    }
}

// MARK: - View
struct PaginationDemo: View {
    @StateObject var viewModel = PaginationDemoViewModel()
    
    var body: some View {
        ZStack {
            
            if viewModel.isLoading {
                ProgressView().scaleEffect(5.0)
                    .progressViewStyle(.circular).tint(.cyan)
                    .zIndex(1)
            }
            
            List {
                ForEach(viewModel.items, id: \.self) { item in
                    Text("\(item)")
                        .onAppear {
                            // If the last element is showed - load more...
                            if item == viewModel.items.last {
                                self.viewModel.loadMoreContent()
                            }
                        }
                }
//                ForEach(0..<viewModel.items.count, id: \.self) { i in
//                    Text("\(viewModel.items[i])")
//                        .onAppear {
//                            // If the last element is showed - load more...
//                            if i + 1 == viewModel.items.count {
//                                self.viewModel.loadMoreContent()
//                            }
//                        }
//                }
            }
        }
    }
}

#Preview {
    PaginationDemo()
}
