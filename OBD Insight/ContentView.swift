import SwiftUI

// Наша модель данных (без изменений)
struct VehicleData {
    var voltage: Double
    var throttle: Double
    var speedOBD: Int
    var speedGPS: Int
    
    var speedError: Int {
        return speedOBD - speedGPS
    }
}

struct ContentView: View {
    // Данные для симуляции
    let currentCar = VehicleData(voltage: 14.2, throttle: 20.0, speedOBD: 95, speedGPS: 90)
    
    var body: some View {
        // В Xcode 12 используем безопасный способ закраски фона
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                // Название нашего приложения
                Text("OBD INSIGHT")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding(.top, 20)
                
                // Главный спидометр
                VStack {
                    Text("\(currentCar.speedOBD)")
                        .font(.system(size: 70, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("КМ/Ч (OBD)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                // Сетка датчиков
                HStack(spacing: 40) {
                    // Используем нашу мини-вьюшку (код ниже)
                    SmallMetricView(label: "GPS", value: "\(currentCar.speedGPS)", unit: "км/ч")
                    SmallMetricView(label: "ОШИБКА", value: "\(currentCar.speedError)", unit: "км/ч", color: .orange)
                }
                
                // Горизонтальный разделитель
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.gray.opacity(0.3))
                    .padding(.horizontal)
                
                HStack(spacing: 60) {
                    SmallMetricView(label: "БОРТСЕТЬ", value: String(format: "%.1f", currentCar.voltage), unit: "V")
                    SmallMetricView(label: "ЗАСЛОНКА", value: "\(Int(currentCar.throttle))", unit: "%")
                }
                
                Spacer()
            }
        }
    }
}

// Вспомогательная вьюшка для датчиков
struct SmallMetricView: View {
    var label: String
    var value: String
    var unit: String
    var color: Color = .white
    
    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.gray)
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(color)
            Text(unit)
                .font(.system(size: 10))
                .foregroundColor(.gray)
        }
    }
}

// Эта часть отвечает за отображение справа в Xcode
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
                .previewDevice("iPhone 11")
        }
    }
}
