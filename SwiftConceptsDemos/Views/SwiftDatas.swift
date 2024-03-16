//
//  SwiftDatas.swift
//  SwiftConceptsDemos
//
//  Created by ETechM23 on 07/03/24.
//

import SwiftUI
import SwiftData

// REf: https://www.hackingwithswift.com/quick-start/swiftdata/filtering-the-results-from-a-swiftdata-query

// MARK: - Data Model
@Model
class Destination {
    var name: String
    var details: String
    var date: Date
    var priority: Int
    @Relationship(deleteRule: .cascade) var sights = [Sight]() // Cascadde means if destination is deleted all its sight will also be deleted

    init(name: String = "", details: String = "", date: Date = .now, priority: Int = Int.random(in: 1...3)) {
        self.name = name
        self.details = details
        self.date = date
        self.priority = priority
    }
}

@Model
class Sight {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

// MARK: - View
struct SwiftDatas: View {
    @Environment(\.modelContext) var modelContext
//    @Query(sort: \Destination.name, order: .reverse) var destinations: [Destination]
    
    @State private var path = [Destination]()
    @State private var sortOrder = SortDescriptor(\Destination.name)
    @State private var searchText = ""
    
    var body: some View {
        
        NavigationStack(path: $path) {
            DestinationListingView(sort: sortOrder, searchString: searchText)
            .navigationTitle("Swift Data")
            .navigationDestination(for: Destination.self, destination: { destination in
                EditDestinationView(destination: destination)
            })
            .searchable(text: $searchText)
            .toolbar {
//                Button("Add Samples") {
//                    addSampleDestinations()
//                }
                Button("Add DEstination", systemImage: "plus") {
                    addDestination()
                }
                
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort", selection: $sortOrder) {
                        Text("Name A-Z")
                            .tag(SortDescriptor(\Destination.name, order: .forward))
                        
                        Text("Name Z-A")
                            .tag(SortDescriptor(\Destination.name, order: .reverse))
                        
                        Text("Priority 📈")
                            .tag(SortDescriptor(\Destination.priority, order: .forward))
                        
                        Text("Priorit 📉")
                            .tag(SortDescriptor(\Destination.priority, order: .reverse))
                        
                        Text("Date 📈")
                            .tag(SortDescriptor(\Destination.date, order: .forward))
                        
                        Text("Date 📉")
                            .tag(SortDescriptor(\Destination.date, order: .reverse))
                    }
                    .pickerStyle(.inline)
                }
            }
        }
    }
}

// MARK: - CRUD Fns
extension SwiftDatas {
    func addSampleDestinations() {
        let samples: [Destination] = [
            .init(name: "Rome"),
            .init(name: "Paris"),
            .init(name: "Germany"),
            .init(name: "Barcelona"),
            .init(name: "Abu Dhabi"),
            .init(name: "Beijing"),
            .init(name: "Dubai"),
            .init(name: "Chicago"),
            .init(name: "Los Angeles"),
            .init(name: "Toronto"),
            .init(name: "London")
        ]
        
        for sample in samples {
            modelContext.insert(sample)
        }
    }
    
    func addDestination() {
        // Here we are first creating data object then pushing the view , so in short first we are adding and then we are editing the empty destinaiton added
        let destination = Destination()
        modelContext.insert(destination)
        path = [destination]
    }
    
 
}

// MARK: - DestinationListing View
struct DestinationListingView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: [SortDescriptor(\Destination.priority, order: .reverse), SortDescriptor(\Destination.name)]) var destinations: [Destination]
    
    init(sort: SortDescriptor<Destination>, searchString: String) {
        _destinations = Query(
            filter: #Predicate {
                if searchString.isEmpty {
                    return true
                } else {
                    return $0.name.localizedStandardContains(searchString)
                }
            }
            ,sort: [sort]
        )
    }
    
    var body: some View {
        List {
            ForEach(destinations) { destination in
                
                NavigationLink(value: destination) {
                    VStack(alignment: .leading) {
                        Text(destination.name)
                            .font(.headline)
                        
                        Text(destination.date.formatted(date: .long, time: .shortened))
                    }
                }
            }
            .onDelete(perform: deleteDestinations)
        }
    }
    
    
    func deleteDestinations(_ indexSet: IndexSet) {
        for index in indexSet {
            let destination = destinations[index]
            modelContext.delete(destination)
        }
    }
}

// MARK: - EditDestinationView
struct EditDestinationView: View {
    @Bindable var destination: Destination
    @State private var newSightName = ""
    
    var body: some View {
        VStack {
            Form {
                TextField("Name", text: $destination.name)
                TextField("Details", text: $destination.details)
                DatePicker("Date", selection: $destination.date)
                
                Section("Priority") {
                    Picker("Priority", selection: $destination.priority) {
                        Text("Low").tag(1)
                        Text("Medium").tag(2)
                        Text("High").tag(3)
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Sights") {
                    ForEach(destination.sights) { sight in
                        Text(sight.name)
                    }
                    
                    HStack {
                        TextField("Add a new sight in \(destination.name)", text: $newSightName)
                        
                        Button("Add", action: addSight)
                    }
                }
                
            }
            .navigationTitle("Edit Destination")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func addSight() {
        guard newSightName.isEmpty == false else {
            return
        }
        
        withAnimation {
            let sight = Sight(name: newSightName)
            destination.sights.append(sight)
            newSightName = ""
        }
    }
}

#Preview {
    SwiftDatas()
}
