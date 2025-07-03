//
//  ContentView.swift
//  TipCalculator
//
//  Created by Selin Samray on 3.07.2025.
//

import SwiftUI


struct ContentView: View {
    @State private var billAmount = ""
    @State private var tipPercentage: Double = 15.0
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var persons: Int = 1
    @State private var amountPerPerson = ""
    
    // Calculate total tip based on bill and tip %
    var totalTip: Double? {
        guard let bill = Double(billAmount), bill >= 0 else { return nil }
        let tip = bill * (tipPercentage / 100)
        return tip
    }
    
    // Calculate total amount
    var totalAmount: Double? {
        guard let bill = Double(billAmount), bill >= 0, let tip = totalTip else { return nil }
        return bill + tip
    }
    
    // Calculate amount each person pays
    var amountPerPersonValue: Double? {
        guard let totalAmount = totalAmount, persons > 0 else { return nil }
        return totalAmount / Double(persons)
    }
    

    var body: some View {
        return ScrollView {
            VStack(spacing: 25) {
                
                // Header with icon and title
                HStack {
                    Image("tip-calc-picture")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 40)

                    Text("Tip Calculator")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .padding(.top, 35)
                .padding(.horizontal, 20)
                
                // Input field for bill amount
                TextField("Enter Bill Amount", text: $billAmount)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .onChange(of: billAmount) {
                        validateInput($0)
                    }
                    .padding(.bottom, 8)
                
                // Stepper to select number of people
                VStack(spacing: 10) {
                    Text("Number of people to split the bill:")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.horizontal, 20)
                    
                    Stepper(value: $persons, in: 1...20) {
                        Text("\(persons) \(persons == 1 ? "person" : "people")")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 8)
                
                // Slider to adjust tip percentage
                VStack(spacing: 10) {
                    Text("Tip Percentage: \(Int(tipPercentage))%")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Slider(value: $tipPercentage, in: 0...30, step: 1)
                        .accentColor(.blue)
                        .padding(.horizontal, 20)
                }

                // Display calculated amounts if inputs are valid
                if let tip = totalTip, let total = totalAmount, let perPerson = amountPerPersonValue {
                    
                    VStack(spacing: 8) {
                        Text("Total Tip")
                            .font(.headline)
                            .foregroundColor(.green)
                        Text("$\(tip, specifier: "%.2f")")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green.opacity(0.15))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 8) {
                            Text("Total Amount:")
                                .font(.headline)
                                .foregroundColor(.blue)
                            Text("$\(total, specifier: "%.2f")")
                                .font(.title2)
                                .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.15))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 8) {
                        Text("Amount per Person")
                            .font(.headline)
                            .foregroundColor(.purple)
                        Text("$\(perPerson, specifier: "%.2f")")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple.opacity(0.15))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                }
                Spacer()
                
            }
            
            // Show alert for invalid input
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Invalid Input"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")))
                
            }
        }
        
        // Validate bill input to allow only positive numbers
        func validateInput(_ input: String) {
            
            if input.isEmpty {
                showAlert = false
                return
            }
            
            if let bill = Double(input), bill >= 0 {
                showAlert = false
            }
            else {
                alertMessage = "Please enter a valid positive number for the bill amount."
                showAlert = true
                
            }
        }
    }
    
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
}
