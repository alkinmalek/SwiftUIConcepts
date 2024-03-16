//
//  DeepLinkings.swift
//  SwiftConceptsDemos
//
//  Created by ETechM23 on 11/03/24.
//

//Ref: https://www.avanderlee.com/swiftui/deeplink-url-handling/

import SwiftUI

struct DeepLinkings: View {
    
    /// We store the opened recipe name as a state property to redraw our view accordingly.
    @State private var openedRecipeName: String?

    var body: some View {
        VStack {
            Text("Hello, recipe!")
            
            Button("Open Recipe") {
                UIApplication
                    .shared
                    .open(URL(string: "deeplink://open-recipe?name=Opened%20from%20inside%20the%20app")!)
            }

            if let openedRecipeName {
                Text("Opened recipe: \(openedRecipeName)")
            }
        }
        .padding()
        /// Responds to any URLs opened with our app. In this case, the URLs
        /// defined inside the URL Types section.
        .onOpenURL { incomingURL in
            print("App was opened via URL: \(incomingURL)")
            handleIncomingURL(incomingURL)
        }
    }

    /// Handles the incoming URL and performs validations before acknowledging.
    private func handleIncomingURL(_ url: URL) {
        guard url.scheme == "recipeapp" else {
            return
        }
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            print("Invalid URL")
            return
        }

        guard let action = components.host, action == "open-recipe" else {
            print("Unknown URL, we can't handle this one!")
            return
        }

        guard let recipeName = components.queryItems?.first(where: { $0.name == "name" })?.value else {
            print("Recipe name not found")
            return
        }

        openedRecipeName = recipeName
    }
}

#Preview {
    DeepLinkings()
}
