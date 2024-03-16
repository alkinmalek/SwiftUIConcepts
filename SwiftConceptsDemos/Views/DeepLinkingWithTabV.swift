//
//  DeepLinkingWithTabV.swift
//  SwiftConceptsDemos
//
//  Created by ETechM23 on 11/03/24.
//

//Ref: https://www.youtube.com/watch?v=OyzFPrVIlQ8&ab_channel=Kavsoft

import SwiftUI

/*
 Deeplink URL Demos:
 1: swiftconceptsdemo://tab=home?nav=deleted_posts   //Change value of nav accordingly
 2: swiftconceptsdemo://tab=favorites?nav=alice
 3: swiftconceptsdemo://tab=settings?nav=terms_of_service
 */

// MARK: - Enums
enum DeepLinkingTabEnum: String, CaseIterable {
    case home = "Home"
    case favorite = "Favorites"
    case setting = "Settings"
    
    var symbolImage: String {
        switch self {
        case .home: return "house.fill"
        case .favorite: return "heart.fill"
        case .setting: return "gear"
        }
    }
    
    static func convert(from: String) -> Self? {
        return DeepLinkingTabEnum.allCases.first { tab in
            tab.rawValue.lowercased() == from.lowercased()
        }
    }
}

// Home View Nav Links
enum DeepLinkingHomeStack: String, CaseIterable {
    case myPosts = "My Posts"
    case oldPosts = "Old Posts"
    case latestPosts = "Latest Posts"
    case deletedPosts = "Deleted Posts"
    
    static func convert(from: String) -> Self? {
        return DeepLinkingHomeStack.allCases.first { tab in
            tab.rawValue.lowercased() == from.lowercased()
        }
    }
}

// Fav View Nav Stack
enum DeepLinkingFavoriteStack: String, CaseIterable {
    case alice = "Alice"
    case iJustine = "iJustine"
    case kaviya = "Kaviya"
    case jenna = "Jenna"
    
    static func convert(from: String) -> Self? {
        return DeepLinkingFavoriteStack.allCases.first { tab in
            tab.rawValue.lowercased() == from.lowercased()
        }
    }
}

// Settings View Nav Stack
enum DeepLinkingSettingStack: String, CaseIterable {
    case myProfile = "My Profile"
    case dataUsage = "Data Usage"
    case privacyPolicy = "Privacy Policy"
    case termsOfServie = "Terms Of Service"
    
    static func convert(from: String) -> Self? {
        return DeepLinkingSettingStack.allCases.first { tab in
            tab.rawValue.lowercased() == from.lowercased()
        }
    }
}


// MyProfile View Nav Stack
enum DeepLinkingMyProfileStack: String, CaseIterable {
    case username = "Username"
    case email = "Email"
    case image = "image"
    case details = "Details"
    
    static func convert(from: String) -> Self? {
        return DeepLinkingMyProfileStack.allCases.first { tab in
            tab.rawValue.lowercased() == from.lowercased()
        }
    }
}


// MARK: - View Model
class DeepLinkingAppData: ObservableObject {
    @Published var activeTab: DeepLinkingTabEnum = .home
    @Published var homeNavStack: [DeepLinkingHomeStack] = []
    @Published var favouriteNavStack: [DeepLinkingFavoriteStack] = []
    @Published var settingNavStack: [DeepLinkingSettingStack] = []
}

// MARK: - Views
struct DeepLinkingWithTabV: View {
    @StateObject private var appData: DeepLinkingAppData = .init()
    
    var body: some View {
        DeepLinkingHome()
            .environmentObject(appData)
        /// Called when Deep Link is Trigerred
            .onOpenURL { url in
                let string = url.absoluteString
                print("Deep Link URL", string)
                /// Splitting URL Components
                let stringTrimmed = string.replacingOccurrences(of: "swiftconceptsdemo://", with: "")
                print("Trimmed Deep Link URL",stringTrimmed)
                let components = stringTrimmed.components(separatedBy: "?")
                
                for component in components {
                    // Tab Change Request
                    if component.contains("tab=") {
                        let tabRawValue = component.replacingOccurrences(of: "tab=", with: "")
                        print(tabRawValue)
                        if let requestedTab = DeepLinkingTabEnum.convert(from: tabRawValue) {
                            appData.activeTab = requestedTab
                        }
                    }
                    
                    
                    
                    // Nav Change Request
                    // Navigation will only be updated if the link contains or specifies which tab navigations need to be changed
                    if component.contains("nav=") && stringTrimmed.contains("tab") {
                        
                        
                        let requestedNavPath = component
                                                .replacingOccurrences(of: "nav=", with: "")
                                                .replacingOccurrences(of: "_", with: " ") //Replacing _ becuase some of the navigation ids contain spaces bt we can't use spaces in deeplink urls.Therefore, we're creating _ to address this problem. This means that if each underscore in the navigation ID represents a space
                      
                        switch appData.activeTab {
                        case .home:
                            if let navPath = DeepLinkingHomeStack.convert(from: requestedNavPath) {
                                appData.homeNavStack.append(navPath)
                            }
                        case .favorite:
                            if let navPath = DeepLinkingFavoriteStack.convert(from: requestedNavPath) {
                                appData.favouriteNavStack.append(navPath)
                            }
                        case .setting:
                            if let navPath = DeepLinkingSettingStack.convert(from: requestedNavPath) {
                                appData.settingNavStack.append(navPath)
                            }
                        }
                    }

                }
            }
    }
}

struct DeepLinkingHome: View {
    @EnvironmentObject private var appData: DeepLinkingAppData
    var body: some View {
        TabView(selection: $appData.activeTab) {
            HomeView()
                .tag(DeepLinkingTabEnum.home)
                .tabItem {
                    Image(systemName: DeepLinkingTabEnum.home.symbolImage)
                }
            
            FavoriteView()
                .tag(DeepLinkingTabEnum.favorite)
                .tabItem {
                    Image(systemName: DeepLinkingTabEnum.favorite.symbolImage)
                }
            
            SettingView()
                .tag(DeepLinkingTabEnum.setting)
                .tabItem {
                    Image(systemName: DeepLinkingTabEnum.setting.symbolImage)
                }
        }
        .tint(.cyan)
    }
    
    // Home View with Nav View's
    @ViewBuilder
    func HomeView() -> some View {
        NavigationStack(path: $appData.homeNavStack) {
            List {
                ForEach(DeepLinkingHomeStack.allCases, id: \.rawValue) { link in
                    NavigationLink(value: link) {
                        Text(link.rawValue)
                    }
                }
            }
            .navigationTitle("Home")
            .navigationDestination(for: DeepLinkingHomeStack.self) { link in
                Text(link.rawValue + " View")
            }
        }
    }
    
    // Favorites View with Nav View's
    @ViewBuilder
    func FavoriteView() -> some View {
        NavigationStack(path: $appData.favouriteNavStack) {
            List {
                ForEach(DeepLinkingFavoriteStack.allCases, id: \.rawValue) { link in
                    NavigationLink(value: link) {
                        Text(link.rawValue)
                    }
                }
            }
            .navigationTitle("Favorite's")
            .navigationDestination(for: DeepLinkingFavoriteStack.self) { link in
                Text(link.rawValue + " View")
            }
        }
    }
    
    // Settings View with Nav View's
    @ViewBuilder
    func SettingView() -> some View {
        NavigationStack(path: $appData.settingNavStack) {
            List {
                ForEach(DeepLinkingSettingStack.allCases, id: \.rawValue) { link in
                    NavigationLink(value: link) {
                        Text(link.rawValue)
                    }
                }
            }
            .navigationTitle("Setting's")
            .navigationDestination(for: DeepLinkingSettingStack.self) { link in
                Text(link.rawValue + " View")
            }
        }
    }
}

#Preview {
    DeepLinkingWithTabV()
}
