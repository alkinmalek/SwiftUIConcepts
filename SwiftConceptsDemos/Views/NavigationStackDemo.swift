//
//  NavigationStackDemo.swift
//  SwiftConceptsDemos
//
//  Created by ETechM23 on 11/03/24.
//

import SwiftUI

struct NavigationStackDemo: View {
    private var bgColors: [Color] = [ .indigo, .yellow, .green, .orange, .brown ]
 
    @State private var path: [Color] = []
 
    var body: some View {
 
        NavigationStack(path: $path) {
            List(bgColors, id: \.self) { bgColor in
 
                NavigationLink(value: bgColor) {
                    Text(bgColor.description)
                }
 
            }
            .listStyle(.plain)
 
            .navigationDestination(for: Color.self) { color in
                VStack {
                    Text("\(path.count), \(path.description)")
                        .font(.headline)
 
                    HStack {
                        ForEach(path, id: \.self) { color in
                            color
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
 
                    }
 
                    List(bgColors, id: \.self) { bgColor in
 
                        NavigationLink(value: bgColor) {
                            Text(bgColor.description)
                        }
 
                    }
                    .listStyle(.plain)
 
                }
            }
 
            .navigationTitle("Color")
 
        }
 
    }
}

#Preview {
    NavigationStackDemo()
}
