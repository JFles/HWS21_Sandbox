////
////  Day2_Session4.swift
////  Day2_Session4
////
////  Created by Jeremy Fleshman on 8/3/21.
////
//
import SwiftUI
//
///// `@MainActor`
enum Day2_Session4 {
//
//    class ViewModel: ObservableObject { }
//
//    struct ContentView: View {
//        /// `@StateObject` inherits from and runs tasks on `@MainActor`
//        @StateObject private var viewModel = ViewModel()
//
//        var body: some View {
//            Button("Do Work", action: doWork)
//        }
//
//        func doWork() {
//            /// These tasks both run on `@MainActor`
//            /// So they run them sequentially and not in parallel
////            Task {
////                for i in 1...10_000 {
////                    print("In task 1: \(i)")
////                }
////            }
////
////            Task {
////                for i in 1...10_000 {
////                    print("In task 2: \(i)")
////                }
////            }
//
//            /// `Task.detached` says not to run in parent Actor's context
//            /// Allows these two tasks to run in parallel
//            Task.detached {
//                for i in 1...10_000 {
//                    print("In task 1: \(i)")
//                }
//            }
//
//            Task.detached {
//                for i in 1...10_000 {
//                    print("In task 2: \(i)")
//                }
//            }
//        }
//    }
//
//    struct ContentView_Previews: PreviewProvider {
//        static var previews: some View {
//            ContentView()
//        }
//    }
//}


class ViewModel: ObservableObject {
}
struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    var body: some View {
        Button("Do Work", action: doWork)
            .task(doWork)
    }
    func doWork() {
        Task.detached {
            for i in 1...10_000 {
                print("In task 1: \(i)")
            }
        }
        Task.detached {
            for i in 1...10_000 {
                print("In task 2: \(i)")
            }
        }
    }
}
}
