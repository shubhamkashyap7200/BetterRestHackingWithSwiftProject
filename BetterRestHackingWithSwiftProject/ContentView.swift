//
//  ContentView.swift
//  BetterRestHackingWithSwiftProject
//
//  Created by Shubham on 1/12/25.
//

import SwiftUI
import CoreML

struct ContentView: View {
//    @State private var sleepAmount = 8.0
//    @State private var wakeUp = Date.now
    
    @State private var wakeUp = defaultWakeUp
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeUp: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("When do you want to wake up?") {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
//                        .labelsHidden()
                }
                
                Section("Desired amount of sleep") {
                    // more
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                Section("Daily coffee intake") {
                    // more
//                    Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 1...20)
                    Picker("^[\(coffeeAmount) cup](inflect: true)", selection: $coffeeAmount) {
                        ForEach(0..<21) {
                            Text($0, format: .number)
                        }
                    }
                }
                
                Section {
                    Text("Your recommended bed time is \(alertMessage)")
                }
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") {
                    
                }
            } message: {
                Text(alertMessage)
            }
            
            
            .navigationTitle("Better Sleep")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Calculate", action: calculateBedTime)
            }
        }
    }
    
    func calculateBedTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            // more
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let predicition = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            
            let sleepTime = wakeUp - predicition.actualSleep
            alertTitle = "Your ideal bedtime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            // error handling
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        
        showingAlert = true
    }
}

#Preview {
    ContentView()
}


//        VStack {
//
//            // Stepper
//            Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.2)
//
//            DatePicker("Pick up a date", selection: $wakeUp, in: Date.now..., displayedComponents: .date)
//                .labelsHidden()
//
//            Text(Date.now, format: .dateTime.hour().minute())
//            Text(Date.now, format: .dateTime.day().month().year())
//            Text(Date.now.formatted(date: .long, time: .shortened))
//
//        }


//func exampleDates() {
////        let tommorow = Date.now.addingTimeInterval(86400)
////        let range = Date.now...tommorow
//    
//    let now =  Date.now
//    let tommorow = Date.now.addingTimeInterval(86400)
//    let range = now...tommorow
//    
//    var components = DateComponents()
//    components.hour = 8
//    components.minute = 0
//    let date = Calendar.current.date(from: components) ?? .now
//    
//    let newComponents = Calendar.current.dateComponents([.hour, .minute], from: Date.now)
//    let hour = newComponents.hour ?? 0
//    let minute = components.minute ?? 0
//}
