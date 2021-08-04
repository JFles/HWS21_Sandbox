//
//  Day3_Session4.swift
//  Day3_Session4
//
//  Created by Jeremy Fleshman on 8/4/21.
//

import SwiftUI

enum Day3_Session4 {

    struct ContentView: View {
        var body: some View {
            Text(exampleString)
        }


        /// `.formatted()` example that will change cm to feet if set to US
        /// Localized measurements
        var exampleString: String {
            let measurement = Measurement(value: 500, unit: UnitLength.centimeters)
            return measurement.formatted()
        }

        /// New Date formatters
//        var exampleString: String {
//            Date.now.formatted(.iso8601)
//        }

        /// New Foundation improvements for Attributed Strings
//        var exampleString: AttributedString {
//            var start = AttributedString("This is some ")
//            start.foregroundColor = .red
//
//            var middle = AttributedString("example")
//            middle.font = .largeTitle.bold()
//
//            var end = AttributedString(" text.")
//            end.tracking = 50
//
//            var overridingAttributes = AttributeContainer()
//            overridingAttributes.backgroundColor = .blue
//
//            var combined = start + middle + end
//            combined.mergeAttributes(overridingAttributes)
//
//            return combined
//        }
    }


    /// Adding custom Toolbar item buttons
//    struct ContentView: View {
//        @State private var show1 = ""
//        @State private var show2 = ""
//
//
//        var body: some View {
//            TextField("Enter your favorite TV show", text: $show1)
//                .textFieldStyle(.roundedBorder)
//                .toolbar {
//                    ToolbarItemGroup(placement: .keyboard) {
//                        Button("Archer") {
//                            show1 = "Archer"
//                        }
//                    }
//                }
//
//            TextField("Enter your favorite TV show", text: $show2)
//                .textFieldStyle(.roundedBorder)
//                .toolbar {
//                    ToolbarItemGroup(placement: .keyboard) {
//                        Button("Ted Lasso") {
//                            show1 = "Ted Lasso"
//                        }
//                    }
//                }
//        }
//    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
