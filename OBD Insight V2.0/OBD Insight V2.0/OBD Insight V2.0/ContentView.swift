//
//  ContentView.swift
//  OBD Insight V2.0
//
//  Created by Никита on 27.03.2026.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView{
        ZStack {
            Color(.systemBackground) // адаптивный фон
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                Text("OBD Insight")
                    .foregroundColor(.primary) // адаптивный текст
                    .font(.title)
                
                NavigationLink {
                    AddVehicleView()
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("Добавить автомобиль")
                    }
                    .foregroundColor(.primary)
                    .padding()
                    .background(Color.secondarySystemBackground)
                    .cornerRadius(12)
                    .shadow(radius: 2)
                }
            }
        }
    }
}
}
