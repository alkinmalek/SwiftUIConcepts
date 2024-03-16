//
//  NavigationStackDeepLinking.swift
//  SwiftConceptsDemos
//
//  Created by ETechM23 on 11/03/24.
//

//Ref: https://www.youtube.com/watch?v=pwP3_OX2G9A&ab_channel=StewartLynch

import SwiftUI
import Charts

// MARK: - Navigation Path

// for opening URL in simulator via terminal : xcrun simctl openurl booted swiftconceptsdemo://Canada/Vancouver

let SCHEME = "swiftconceptsdemo"

/*
 DemoDeepLinks:
 1. swiftconceptsdemo://United%20Kingdom
 1. swiftconceptsdemo://France/Toulon
 2. swiftconceptsdemo://United%20States/Washington/
 3. swiftconceptsdemo://Canada/Toronto/Scarborough%20St
 */

class NavigationStackDeepLinkingRouter: ObservableObject {
    @Published var path = NavigationPath()
    
    // Go to Root
    func reset() {
        path = NavigationPath()
    }
}

// MARK: - Models
struct Country: Identifiable, Hashable {
    var name: String
    var flag: String
    var population: Int
    var cities: [City]
    var id: String {
        name
    }

    static var sample: [Country] {
        [
            Country(name: "Canada", flag: "🇨🇦", population: 36991981, cities: City.all.filter{$0.country == "Canada"}),
            Country(name: "United States", flag: "🇺🇸", population: 332278200, cities: City.all.filter{$0.country == "United States"}),
            Country(name: "United Kingdom", flag: "🇬🇧", population: 67886004, cities: City.all.filter{$0.country == "United Kingdom"}),
            Country(name: "France", flag: "🇫🇷", population: 67413000, cities: City.all.filter{$0.country == "France"}),
            Country(name: "Mexico", flag: "🇲🇽", population: 128830, cities:  City.all.filter{$0.country == "Mexico"}),
        ]
    }
}


struct City: Identifiable, Hashable {
    var name: String
    var country: String
    var isCapital: Bool
    var population: Int
    var id: String {
        name
    }
    
    var streets: [Street]
    
    static var all: [City] {
        [
            City(name: "Vancouver", country: "Canada", isCapital: false, population:  2632000, streets: Street.all.filter{ $0.city == "Vancouver" }),
            City(name: "Victoria", country: "Canada", isCapital: false, population: 394000, streets: Street.all.filter{ $0.city == "Victoria" }),
            City(name: "Toronto", country: "Canada", isCapital: false, population: 6313000, streets: Street.all.filter{ $0.city == "Toronto" }),
            City(name: "Ottawa", country: "Canada", isCapital: true, population: 1433000, streets: Street.all.filter{ $0.city == "Ottawa" }),
            City(name: "Seattle", country: "United States", isCapital: false, population: 4102100, streets: Street.all.filter{ $0.city == "Seattle" }),
            City(name: "Denver", country: "United States", isCapital: false, population: 2897000, streets: Street.all.filter{ $0.city == "Denver" }),
            City(name: "San Francisco", country: "United States", isCapital: false, population: 3318000, streets: Street.all.filter{ $0.city == "San Francisco" }),
            City(name: "Washington", country: "United States", isCapital: true, population: 5434000, streets: Street.all.filter{ $0.city == "Washington" }),
            City(name: "London", country: "United Kingdom", isCapital: true, population: 95410000, streets: Street.all.filter{ $0.city == "London" }),
            City(name: "Glasgow", country: "United Kingdom", isCapital: false, population: 1689000, streets: Street.all.filter{ $0.city == "Glasgow" }),
            City(name: "Cardiff", country: "United Kingdom", isCapital: false, population: 485000, streets: Street.all.filter{ $0.city == "Cardiff" }),
            City(name: "Leeds", country: "United Kingdom", isCapital: false, population: 780000, streets: Street.all.filter{ $0.city == "Leeds" }),
            City(name: "Edinburgh", country: "United Kingdom", isCapital: false, population: 548000, streets: Street.all.filter{ $0.city == "Edinburgh" }),
            City(name: "Belfast", country: "United Kingdom", isCapital: false, population: 630000, streets: Street.all.filter{ $0.city == "Belfast" }),
            City(name: "Lyon", country: "France", isCapital: false, population: 1748000, streets: Street.all.filter{ $0.city == "Lyon" }),
            City(name: "Paris", country: "France", isCapital: true, population: 2140000, streets: Street.all.filter{ $0.city == "Paris" }),
            City(name: "Marseille", country: "France", isCapital: false, population: 1620000, streets: Street.all.filter{ $0.city == "Marseille" }),
            City(name: "Toulon", country: "France", isCapital: false, population: 584000, streets: Street.all.filter{ $0.city == "Toulon" }),
            City(name: "Nice", country: "France", isCapital: false, population: 945000, streets: Street.all.filter{ $0.city == "Nice" }),
            City(name: "Tijuana", country: "Mexico", isCapital: false, population: 2221000, streets: Street.all.filter{ $0.city == "Tijuana" }),
            City(name: "Mexico City", country: "Mexico", isCapital: true, population: 22085000, streets: Street.all.filter{ $0.city == "Mexico City" }),
            City(name: "Cancun", country: "Mexico", isCapital: false, population: 998000, streets: Street.all.filter{ $0.city == "Cancun" }),
            City(name: "Monterrey", country: "Mexico", isCapital: false, population: 1135000, streets: Street.all.filter{ $0.city == "Monterrey" }),
            City(name: "Iztapalapa", country: "Mexico", isCapital: false, population: 1815000, streets: Street.all.filter{ $0.city == "Iztapalapa" }),
            City(name: "Puebla", country: "Mexico", isCapital: false, population: 1434000, streets: Street.all.filter{ $0.city == "Puebla" }),
            City(name: "Chihuahua", country: "Mexico", isCapital: false, population: 809232, streets: Street.all.filter{ $0.city == "Chihuahua" })
        ]
    }
    
    var fellowCities: [City] {
        Self.all.filter {$0.country == country}
    }
}

struct Street: Identifiable, Hashable {
    var name: String
    var city: String
    var isMainStreet: Bool
    var population: Int
    
    static var all: [Street] {
        [
            Street(name: "Hortons St", city: "Vancouver", isMainStreet: true, population: Int.random(in: 999...99999)),
            Street(name: "Tom Jonas St", city: "Victoria", isMainStreet: true, population: Int.random(in: 999...99999)),
            Street(name: "Scarborough St", city: "Toronto", isMainStreet: true, population: Int.random(in: 999...99999)),
            Street(name: "Missisuaga St", city: "Toronto", isMainStreet: false, population: Int.random(in: 999...99999)),
            Street(name: "Edmund St", city: "Toronto", isMainStreet: false, population: Int.random(in: 999...99999)),
            Street(name: "Whitby St", city: "Toronto", isMainStreet: false, population: Int.random(in: 999...99999)),
            Street(name: "Alan Price St", city: "Ottawa", isMainStreet: true, population: Int.random(in: 999...99999)),
            Street(name: "Leons St", city: "Seattle", isMainStreet: true, population: Int.random(in: 999...99999)),
            Street(name: "Sharp Angel St", city: "Denver", isMainStreet: true, population: Int.random(in: 999...99999)),
            Street(name: "Brampton St", city: "San Francisco", isMainStreet: true, population: Int.random(in: 999...99999)),
            Street(name: "Nova St", city: "Washington", isMainStreet: true, population: Int.random(in: 999...99999)),
            Street(name: "Bolton St", city: "London", isMainStreet: true, population: Int.random(in: 999...99999)),
            Street(name: "Lucky St", city: "Glasgow", isMainStreet: true, population: Int.random(in: 999...99999)),
            Street(name: "Camilla St", city: "Cardiff", isMainStreet: true, population: Int.random(in: 999...99999)),
            Street(name: "Monkey St", city: "Leeds", isMainStreet: true, population: Int.random(in: 999...99999)),
            Street(name: "Socket St", city: "Edinburgh", isMainStreet: true, population: Int.random(in: 999...99999)),
            Street(name: "Boston St", city: "Belfast", isMainStreet: true, population: Int.random(in: 999...99999)),
            Street(name: "Kelly's St", city: "Lyon", isMainStreet: true, population: Int.random(in: 999...99999)),
            Street(name: "Eiffel St", city: "Paris", isMainStreet: true, population: Int.random(in: 999...99999)),
            Street(name: "York St", city: "Marseille", isMainStreet: true, population: Int.random(in: 999...99999)),
            Street(name: "Oswald St", city: "Toulon", isMainStreet: true, population: Int.random(in: 999...99999)),
            Street(name: "Norman St", city: "Nice", isMainStreet: true, population: Int.random(in: 999...99999)),
            Street(name: "Epicson St", city: "Tijuana", isMainStreet: true, population: Int.random(in: 999...99999)),
            Street(name: "Los Santos", city: "Mexico City", isMainStreet: true, population: Int.random(in: 999...99999)),
            Street(name: "Simpsons St", city: "Cancun", isMainStreet: true, population: Int.random(in: 999...99999)),
            Street(name: "Evil St", city: "Monterrey", isMainStreet: true, population: Int.random(in: 999...99999)),
            Street(name: "Red St", city: "Iztapalapa", isMainStreet: true, population: Int.random(in: 999...99999)),
            Street(name: "Black St", city: "Puebla", isMainStreet: true, population: Int.random(in: 999...99999)),
            Street(name: "Gulf St", city: "Chihuahua", isMainStreet: true, population: Int.random(in: 999...99999)),
            
        ]
    }
    
    
    var id: String {
        name
    }
}

struct NavigationStackDeepLinking: View {
    @StateObject var router = NavigationStackDeepLinkingRouter()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            List(Country.sample) { country in NavigationLink(value: country) {
                HStack {
                    Text(country.flag)
                    Text(country.name)
                    
                }
            }
                
            }
            .navigationTitle("Countries")
            .navigationDestination(for: Country.self) { country in
                CountryView(country: country)
            }
        }
        .environmentObject(router)
        .onOpenURL { url in
            guard let scheme = url.scheme, scheme == SCHEME else {
                return
            }
            
            guard  let country = url.host else {
                return
            }
            
            if let foundCountry = Country.sample.first(where: { $0.name == country }) {
                router.reset()
                router.path.append(foundCountry)
                if url.pathComponents.count == 2 || url.pathComponents.count == 3 {
                    let city = url.pathComponents[1]
                    if let foundCity = foundCountry.cities.first(where: { $0.name == city }) {
                        router.path.append(foundCity)
                        
                        if url.pathComponents.count == 3 {
                            let street = url.pathComponents[2]
                            if let foundStreet = foundCity.streets.first(where: { $0.name == street }) {
                                router.path.append(foundStreet)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct CountryView: View {
    @EnvironmentObject var router: NavigationStackDeepLinkingRouter
    
    var country: Country
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(country.flag)
                Text(country.name)
                
            }
            .font(.largeTitle)
            
            HStack {
                Spacer()
                
                Text("Population: \(country.population)")
            }
            
            List(country.cities) { city in
                NavigationLink(value: city) {
                    Text(city.name)
                }
            }
        }
        .padding()
        .navigationTitle("Country")
        .navigationDestination(for: City.self) { city in
            CityView(city: city)
        }
    }
}

struct CityView: View {
    @EnvironmentObject var router: NavigationStackDeepLinkingRouter
    let city: City
    
    var body: some View {
        
        VStack {
            ZStack {
                if city.isCapital {
                    Text("🌟")
                        .font(.system(size: 100))
                }
                
                HStack {
                    Text("\(city.name) (\(city.country))")
                        .font(.title2)
                }
            }
            .frame(height: 120)
            
            List(city.streets) { street in
                NavigationLink(value: street) {
                    Text(street.name)
                }
            }
            
            Chart(city.fellowCities) { city in
                BarMark(
                    x: .value("City", city.name),
                    y: .value("Population", city.population)
                )
                .foregroundStyle(by: .value("City", city.name))
            }
            .chartLegend(.hidden)
            .padding()
            
//            Button("Back to Countries List") {
//                router.reset()
//            }
//            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("City")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Street.self) { street in
            StreetView(street: street)
        }
    }
}

struct StreetView: View {
    @EnvironmentObject var router: NavigationStackDeepLinkingRouter
    let street: Street
    
    var body: some View {
        VStack {
            Text("\(street.name)" )
            ZStack {
                if street.isMainStreet {
                    Text("🌟")
                        .font(.system(size: 200))
                }
                
                HStack {
                    Text("\(street.name) (\(street.city))")
                        .font(.title2)
                }
            }
            .frame(height: 220)
            
            Spacer()
            
            Button("Back to Countries List") {
                router.reset()
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationTitle("Street")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStackDeepLinking()
}
