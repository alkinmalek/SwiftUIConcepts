//
//  GesturesDemo.swift
//  SwiftConceptsDemos
//
//  Created by ETechM23 on 08/03/24.
//

//Ref: https://www.hackingwithswift.com/books/ios-swiftui/how-to-use-gestures-in-swiftui
//Ref: https://sarunw.com/posts/move-view-around-with-drag-gesture-in-swiftui/

import SwiftUI

enum GesturesDemoEnum: String,CaseIterable {
    case none = ""
    case tapSingle = "Single Tap Gesture"
    case tapDouble = "Double Tap Gesture"
    case long = "Long Tap Gesture"
    case magnify = "Magnify Gesture"
    case rotate = "Rotate Gesture"
    case drag = "Drag Gesture"
    case highPriority = "High Priority Gesture"
    case simultaneous = "Simultaneous Gesture"
    case sequence = "Sequence"
    
}

struct GesturesDemo: View {
    @State var selectedGesture: GesturesDemoEnum = .none
    @State var currentCount: Int = 0
    @State var scaleF: CGFloat = 1.0
    @State private var currentAmount = 0.0
    @State private var finalAmount = 1.0
    @State private var currentAngle = Angle.zero
    @State private var finalAngle = Angle.zero
    
    // how far the circle has been dragged
    @State private var offset = CGSize.zero

    // whether it is currently being dragged or not
    @State private var isDragging = false
    
    @State private var location: CGPoint = CGPoint(x: 0, y: 0)
    
    var body: some View {
        VStack {
            switch selectedGesture {
            case .none:
                home()
            case .tapSingle:
                singleTap(gesture: .tapSingle)
            case .tapDouble:
                doubleTap(gesture: .tapDouble)
            case .long:
                long(gesture: .long)
            case .magnify:
                magnify(gesture: .magnify)
            case .rotate:
                rotate(gesture: .rotate)
            case .drag:
                drag(gesture: .drag)
            case .highPriority:
                highPriority(gesture: .highPriority)
            case .simultaneous:
                simultaneous(gesture: .simultaneous)
            case .sequence:
                sequence(gesture: .sequence)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

extension GesturesDemo {
    @ViewBuilder
    func home() -> some View {
        List {
            ForEach(GesturesDemoEnum.allCases, id: \.self) { gesturez in
                if gesturez != .none {
                    Text(gesturez.rawValue)
                        .padding()
                        .onTapGesture {
                            selectedGesture = gesturez
                        }
                }
            }
        }
    }
    
    @ViewBuilder
    func singleTap(gesture: GesturesDemoEnum) -> some View {
        Text(gesture.rawValue)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) {
                Button("Back", systemImage: "chevron.left") {
                    withAnimation(.snappy) {
                        currentCount = 0
                        selectedGesture = .none
                    }
                }
                .padding()
            }
        
        VStack {
            Text("Tap To increase count")
                .onTapGesture {
                    currentCount += 1
                }
                .foregroundStyle(.cyan)
            Text("Count - \(currentCount)")
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    @ViewBuilder
    func doubleTap(gesture: GesturesDemoEnum) -> some View {
        Text(gesture.rawValue)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) {
                Button("Back", systemImage: "chevron.left") {
                    withAnimation(.snappy) {
                        currentCount = 0
                        selectedGesture = .none
                    }
                }
                .padding()
            }
        
        
        VStack {
            Text("Double Tap To increase count")
                .onTapGesture(count: 2) {
                    currentCount += 1
                }
                .foregroundStyle(.cyan)
            Text("Count - \(currentCount)")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    @ViewBuilder
    func long(gesture: GesturesDemoEnum) -> some View {
        Text(gesture.rawValue)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) {
                Button("Back", systemImage: "chevron.left") {
                    withAnimation(.snappy) {
                        selectedGesture = .none
                        scaleF = 1.0
                    }
                }
                .padding()
            }
        
        
        VStack {
            
            Text("Long Press to increase Scale")
                .scaleEffect(scaleF)
                .onLongPressGesture {
                    scaleF += 0.1
                }
                .padding(.bottom,60)
            
            Text("Long Press 2 secs to increase Scale")
                .scaleEffect(scaleF)
                .onLongPressGesture(minimumDuration: 5.0) {
                    print("Long pressed!")
                } onPressingChanged: { bool in
                    if bool { scaleF += 0.1 }
                }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    @ViewBuilder
    func magnify(gesture: GesturesDemoEnum) -> some View {
        Text(gesture.rawValue)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) {
                Button("Back", systemImage: "chevron.left") {
                    withAnimation(.snappy) {
                        selectedGesture = .none
                        currentAmount = 0
                        finalAmount = 1
                    }
                }
                .padding()
            }
        
        
        VStack {
            Image(.pic)
                .resizable()
                .frame(width: 100, height: 100)
                .scaleEffect(finalAmount + currentAmount)
                .scaledToFill()
                .gesture(
                MagnifyGesture()
                    .onChanged({ value in
                        currentAmount = value.magnification - 1
                        print("Magnification Value: \(value.magnification),Current Amount: \(currentCount), final AmounT: \(finalAmount)")
                    })
                    .onEnded({ value in
                        finalAmount += currentAmount
//                        print("Current Amount: \(currentCount), final AmounT: \(finalAmount)")
                        currentAmount = 0
                    })
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    @ViewBuilder
    func rotate(gesture: GesturesDemoEnum) -> some View {
        Text(gesture.rawValue)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) {
                Button("Back", systemImage: "chevron.left") {
                    withAnimation(.snappy) {
                        selectedGesture = .none
                        currentAngle = .zero
                        finalAngle = .zero
                    }
                }
                .padding()
            }
        
        
        VStack {
            Image(.pic)
                .resizable()
                .frame(width: 300, height: 300)
                .rotationEffect(currentAngle + finalAngle)
                .scaledToFill()
                .gesture(
                RotateGesture()
                    .onChanged({ value in
                        currentAngle = value.rotation
                    })
                    .onEnded({ value in
                        finalAngle += currentAngle
                        currentAngle = .zero
                    })
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    @ViewBuilder
    func drag(gesture: GesturesDemoEnum) -> some View {
        Text(gesture.rawValue)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) {
                Button("Back", systemImage: "chevron.left") {
                    withAnimation(.snappy) {
                        selectedGesture = .none
                    }
                }
                .padding()
            }
        
        
    
            
            GeometryReader {
                
                let size = $0.size
                VStack {
                Text("Red : Drag with location, Cyan : Drag with Offset")
                
                RoundedRectangle(cornerRadius: 10)
                           .foregroundColor(.pink)
                           .frame(width: 100, height: 100)
                           .position(location)
                           .gesture(
                            DragGesture()
                                      .onChanged { value in
                                          self.location = value.location
                                      }
                           )
                
                RoundedRectangle(cornerRadius: 30)
                    .fill(.cyan)
                    .frame(width: 100, height: 50)
                    .offset(offset)
                    .gesture(
                    DragGesture()
                        .onChanged({ value in
                            offset = value.translation
                        })
                        .onEnded({ value  in
                            withAnimation(.spring) {
                                offset = .zero
                            }
                        })
                    
                    )
                
            }
                .onAppear {
                    print("SCreen Hright: \(SCREEN_HEIGHT)\n Geo hEight: \(size.height)")
                    location = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
                }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    @ViewBuilder
    func highPriority(gesture: GesturesDemoEnum) -> some View {
        Text(gesture.rawValue)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) {
                Button("Back", systemImage: "chevron.left") {
                    withAnimation(.snappy) {
                        selectedGesture = .none
                    }
                }
                .padding()
            }
        
        
        VStack {
            VStack {
                     Text("High Priority Gesture!")
                         .onTapGesture {
                             print("Text tapped")
                         }
                 }
                 .highPriorityGesture(
                     TapGesture()
                         .onEnded {
                             print("VStack tapped")
                         }
                 )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    @ViewBuilder
    func simultaneous(gesture: GesturesDemoEnum) -> some View {
        Text(gesture.rawValue)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) {
                Button("Back", systemImage: "chevron.left") {
                    withAnimation(.snappy) {
                        selectedGesture = .none
                    }
                }
                .padding()
            }
        
        
        VStack {
            VStack {
                      Text("Simultaneous Gesture!")
                          .onTapGesture {
                              print("Text tapped")
                          }
                  }
                  .simultaneousGesture(
                      TapGesture()
                          .onEnded {
                              print("VStack tapped")
                          }
                  )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    
    @ViewBuilder
    func sequence(gesture: GesturesDemoEnum) -> some View {
        // a drag gesture that updates offset and isDragging as it moves around
        let dragGesture = DragGesture()
            .onChanged { value in offset = value.translation }
            .onEnded { _ in
                withAnimation {
                    offset = .zero
                    isDragging = false
                }
            }

        // a long press gesture that enables isDragging
        let pressGesture = LongPressGesture()
            .onEnded { value in
                withAnimation {
                    isDragging = true
                }
            }

        // a combined gesture that forces the user to long press then drag
        let combined = pressGesture.sequenced(before: dragGesture)
        
        Text(gesture.rawValue)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) {
                Button("Back", systemImage: "chevron.left") {
                    withAnimation(.snappy) {
                        selectedGesture = .none
                    }
                }
                .padding()
            }
        
        
        VStack {
            // a 64x64 circle that scales up when it's dragged, sets its offset to whatever we had back from the drag gesture, and uses our combined gesture
            Circle()
                .fill(.red)
                .frame(width: 64, height: 64)
                .scaleEffect(isDragging ? 1.5 : 1)
                .offset(offset)
                .gesture(combined)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

#Preview {
    GesturesDemo()
}
