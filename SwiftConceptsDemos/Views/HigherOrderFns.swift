//
//  HigherOrderFns.swift
//  SwiftConceptsDemos
//
//  Created by ETechM23 on 06/03/24.
//

// Ref: https://www.tutorialspoint.com/what-are-the-higher-order-functions-in-swift

import SwiftUI

enum HigherOrderEnum: String, CaseIterable {
    case foreach = "For each"
    case map = "Map"
    case compactMap = "Compact Map"
    case flatMap = "Flat Map"
    case filter = "Filter"
    case reduce = "Reduce"
    case sort = "Sort"
    case sorted = "Sorted"
}

struct HigherOrderFns: View {
    @State var txt: String = "Hello"
    
    var body: some View {
        VStack {
            
            List {
                ForEach(HigherOrderEnum.allCases, id: \.rawValue) { highOrder in
                    
                    Button {
                        switch highOrder {
                        case .foreach:
                            forEachExample()
                        case .map:
                            mapExample()
                        case .compactMap:
                            compactMapExample()
                        case .flatMap:
                            flatMapExample()
                        case .filter:
                            filterExample()
                        case .reduce:
                            reduceExample()
                        case .sort:
                            sortExample()
                        case .sorted:
                            sortedExample()
                        }
                    } label: {
                        Text(highOrder.rawValue)
                    }
                }
            }
            .listStyle(.plain)
            .listRowSeparator(.hidden)
            .padding()
            
            Text(txt)
                .padding()
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.cyan)
                )
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear(perform: {
            forEachExample()
        })
    }
}

// MARK: - Fns
extension HigherOrderFns {
   // MARK: - For Each
    /*
     It will iterate through all the elements in a collection (eg array) and not return anything. Remember that you cannot use continue and break inside the forEach function to exit the currently executing statement.

     The ForEach function is similar to the for-in loop with a difference i.e. you cannot use continue and break statements in the forEach function.
     */
    
    func forEachExample() {
        txt = ""
        let numbersInWord = ["One", "Two", "Three", "Four", "Five", "Six"]
        numbersInWord.forEach {
           element in 
            txt = txt + " " + element
            print(element)
        }
    }
    
    // MARK: - Map
    /*
     The map function works by performing an operation on all the elements of a collection and returning a new collection with the results of that operation.

     This function is designed to transform an object from one type to another type (as well as the same type).
     */
    func mapExample() {
        txt = ""
        let numbers = [1, 2, 3, 4, 5, 6, 7]
        let numbersInString = numbers.map {  number in
            String(number)
        }
        txt = "Numbers converted to String using Map\n \(numbersInString)\n\n"
        
        let lowercasedNumbers = ["one", "two", "three", "four"]
        let uppercasedNumbers = lowercasedNumbers.map({ $0.uppercased() })
        print("uppercasedNumbers: \(uppercasedNumbers)")
        txt += "Lowercased converted to uppercase using Map\n \(uppercasedNumbers)"
    }
    
    // MARK: - Compact Map
    /*
     Iterating through the elements in an array, compactMap() returns an updated array only containing elements that satisfy the condition stated within its body. The array will be updated without any elements that result in a nil value.

     As a result, compactMap loops through all the elements in the array and returns non-nil values.
     */
    func compactMapExample() {
        txt = ""
        let numbersInString = ["1", "x2", "3", "4", nil, "five5"]
        
        let validNumbers = numbersInString.compactMap {
            stringValue in
            Int(stringValue ?? "")
        }
        print("validNumbers: \(validNumbers)")
        txt = "Valid numbers from \(numbersInString) using compactMap are: \n\(validNumbers)"
    }
    
    // MARK: - Flat Map
    /*
     The flatMap function allows us to transform a set of arrays into a single set that contains all of the elements.

     Example
     Here is an array that contains other arrays as elements. Suppose each inner array contains a student's marks for three different courses −

     let marks = [[3, 4, 5], [2, 5, 3], [1, 2, 2], [5, 5, 4], [3, 5, 3]]

     Now we have to combine all the marks and get the result into a single array.

     We can perform a for-in loop and append all elements of each array to a result array. But why would you need to do it manually if you have a flatMap function provided by the Swift language? It takes less effort and is more optimized.
     */
    func flatMapExample() {
        txt = ""
        let marks = [[3, 4, 5], [2, 5, 3], [1, 2, 2], [5, 5, 4], [3, 5, 3]]
        let allMarks = marks.flatMap {
           marksArray -> [Int] in
           marksArray
        }
        print("allMarks: \(allMarks)")
        txt = "Marks before: \n\(marks) \n\n Marks after flatMap \n \(allMarks)"
    }
    
    // MARK: - Filter
    /*
     The filter() will iterate through all elements in an array and will return an updated array only with the elements which satisfy the condition written inside the body of the filter.

     In Swift, it is always an essential function. While you write code, many times you need to filter out collections to produce a filtered collection based on a condition.

     The return type of the closure is a Bool value; items in the resulting array are those that satisfy the condition inside the body;
     */
    func filterExample() {
        txt = ""
        let numbers = [-12, 23, -1, 56, 9, -2, 0, 14, 8]
        let positives = numbers.filter {
           number in
           number > 0
        }
        print("positives: \(positives)")
        txt = "Numbers : \n\(numbers) \n\n After Filter: \n\(positives)"
    }
    
    // MARK: - Reduce
    /*
     The reduce function will iterate through all elements in an array and return an object with the combined value of all elements.
     */
    func reduceExample() {
        txt = ""
        let numbers = [1, 5, 2, 10, 6]
        let sum = numbers.reduce(0) {  // Here 0 is initial result
           (result, number) -> Int in
           result + number
        }
        print("sum:", sum)
        txt = "Numbers : \n \(numbers) \n\n After Reduce: \n\(sum)"
    }
    
    // MARK: - Sort
    /*
     The sort function will sort all elements according to the condition written inside the body of the closure.
     */
    func sortExample() {
        txt = ""
        var numbers = [1, 99, 10, 28, 6]
        txt = "Number :\n \(numbers)"
        numbers.sort()
        print("Sorted numbers: \(numbers)")
        txt += "\n\n After sort: \n\(numbers)"
    }
    
    
    // MARK: - Sorted
    /*
     The sorted function will sort all elements according to the condition written inside the body of the closure and return a new sorted array.
     */
    func sortedExample() {
        txt = ""
        let numbers = [1, 1001, 99, 10, 58]
        let sortedArray = numbers.sorted()
        print("sortedArray:", sortedArray)
        txt += "Number : \n\(numbers)\n\n After sorted: \n\(sortedArray)"
    }
}

#Preview {
    HigherOrderFns()
}
