import SwiftUI

struct VehicleData {
    var voltage: Double
    var throttle: Double
    var speedOBD: Int
    var speedGPS: Int
    var speedError: Int {
        return speedOBD - speedGPS
    }
    var fuelConsumption: Double
    var errorMessage: String = "Ошибок нет"
    
    // НОВЫЕ ПОЛЯ ДЛЯ ЖУРНАЛА:
    var totalFuelSum: Double = 0.0
    var measurementsCount: Int = 0
    var fuelHistory: [Double] = [] // Массив для истории
    var currentTripDistance: Double = 0.0
    
    // Вычисляемое свойство (считает среднее на лету)
    var averageFuel: Double {
        return measurementsCount > 0 ? totalFuelSum / Double(measurementsCount) : 0.0
    }
}


struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme

    // Данные для симуляции
    @State var currentCar = VehicleData(
        voltage: 14.2,
        throttle: 20.0,
        speedOBD: 0,
        speedGPS: 0,
        fuelConsumption: 0.8,
        errorMessage: "Ошибок нет",
        totalFuelSum: 0.0,
        measurementsCount: 0,
        fuelHistory: [],
        currentTripDistance: 0.0
    )


    // Добавим финкцию, которая прибавляет скорость
    func accelerate(by amount: Int) {
        self.currentCar.speedOBD += amount
        // Твоя идея: шаг в 0.1 для максимальной точности
        self.currentCar.fuelConsumption += 0.1
        // Также не забудем про дроссель (заслонку) — она тоже открывается при газе
        self.currentCar.throttle += 2.0
    }

    
    // Добавим функцию торможения с ограничением минусовых значений
    func decelerate(by amount: Int) {
        // 1. Снижаем скорость (не ниже 0)
        if self.currentCar.speedOBD >= amount {
            self.currentCar.speedOBD -= amount
        } else {
            self.currentCar.speedOBD = 0
        }
        
        // 2. Снижаем расход (не ниже 0)
        // Мы просто имитируем замедление, но не ограничиваем его снизу цифрой 0.8
        if self.currentCar.fuelConsumption >= 0.1 {
            self.currentCar.fuelConsumption -= 0.1
        } else {
            self.currentCar.fuelConsumption = 0
        }
    }
    
    func simulateCarLife() {
        // --- 1. Электрика и заслонка (твоя старая логика) ---
        self.currentCar.voltage = Double.random(in: 13.8...14.2)
        
        if self.currentCar.throttle < 100 {
            self.currentCar.throttle += 1.0
        } else {
            self.currentCar.throttle = 0
        }
        
        // --- 2. Движение и накопление данных (новая логика) ---
        // Пока мы просто имитируем, что машина едет (speedOBD > 0)
        // Для теста можешь временно убрать "if", если хочешь, чтобы пробег шел всегда
        if self.currentCar.speedOBD >= 0 {
            self.currentCar.currentTripDistance += 0.5
        }
        
        self.currentCar.totalFuelSum += self.currentCar.fuelConsumption
        self.currentCar.measurementsCount += 1
        
        // --- 3. Проверка отсечки 100 км ---
        if self.currentCar.currentTripDistance >= 100.0 {
            let report = self.currentCar.averageFuel
            
            // Вставляем свежий отчет в начало списка
            self.currentCar.fuelHistory.insert(report, at: 0)
            
            // Удаляем старые, если их больше 5
            if self.currentCar.fuelHistory.count > 5 {
                self.currentCar.fuelHistory.removeLast()
            }
            
            // Сбрасываем счетчики для следующего круга
            self.currentCar.currentTripDistance = 0
            self.currentCar.totalFuelSum = 0
            self.currentCar.measurementsCount = 0
        }
    }


    func checkVehicleSystems() {
        // 1. Логика проверки напряжения
        if self.currentCar.voltage < 11.5 {
            self.currentCar.errorMessage = "НИЗКИЙ ЗАРЯД АКБ!"
        } else if self.currentCar.voltage > 15.0 {
            self.currentCar.errorMessage = "ПЕРЕЗАРЯД (ПРОВЕРЬТЕ РЕЛЕ)!"
        } else {
            self.currentCar.errorMessage = "Ошибок нет"
        }
        
        // 2. Сюда же в будущем добавим проверку температуры, давления и т.д.
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    
    var body: some View {
        // В Xcode 12 используем безопасный способ закраски фона
        ZStack {
            // 1. Адаптивный фон: подстраивается под систему
            (colorScheme == .dark ? Color.black : Color(UIColor.systemBackground))
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                // Название приложения
                Text("OBD INSIGHT")
                    .font(.headline)
                    .foregroundColor(.blue) // Синий хорошо смотрится везде
                    .padding(.top, 20)
                
                // Главный спидометр
                VStack {
                    Text("\(currentCar.speedOBD)")
                        .font(.system(size: 70, weight: .bold, design: .rounded))
                        .foregroundColor(.primary) // СТАНЕТ ЧЕРНЫМ НА БЕЛОМ И НАОБОРОТ
                    Text("КМ/Ч (OBD)")
                        .font(.caption)
                        .foregroundColor(.secondary) // СТАНЕТ СЕРЫМ
                }
                
                // Сетка датчиков (GPS и Ошибка)
                HStack(spacing: 40) {
                    SmallMetricView(label: "GPS", value: "\(currentCar.speedGPS)", unit: "км/ч")
                    SmallMetricView(label: "ОШИБКА", value: "\(currentCar.speedError)", unit: "км/ч", color: .orange)
                }
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.gray.opacity(0.3))
                    .padding(.horizontal)
                
                // Блок истории
                VStack(alignment: .leading, spacing: 10) {
                    Text("ИСТОРИЯ (ПОСЛЕДНИЕ 100 КМ)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    ForEach(currentCar.fuelHistory, id: \.self) { report in
                        HStack {
                            Image(systemName: "fuelpump.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                            Text("Завершенный этап:")
                                .foregroundColor(.primary)
                            Spacer()
                            Text(String(format: "%.1f L/100", report))
                                .bold()
                                .foregroundColor(report > 10.0 ? .red : (report < 7.0 ? .green : .primary))
                        }
                        .padding(8)
                        // ИСПОЛЬЗУЕМ PRIMARY С ОПАСТЬЮ: на белом будет темная подложка, на черном - светлая
                        .background(Color.primary.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                
                // Кнопка симуляции
                Button(action: {
                    self.currentCar.currentTripDistance = 100.0
                    self.simulateCarLife()
                }) {
                    Text("ИМИТИРОВАТЬ 100 КМ")
                        .font(.caption)
                        .padding(8)
                        .background(Color.blue.opacity(0.3))
                        .foregroundColor(.primary)
                        .cornerRadius(8)
                }
                
                // Нижняя панель датчиков
                HStack(spacing: 30) {
                    SmallMetricView(label: "Напряжение", value: String(format: "%.1f", currentCar.voltage), unit: "V")
                    SmallMetricView(label: "ЗАСЛОНКА", value: "\(Int(currentCar.throttle))", unit: "%")
                    SmallMetricView(
                        label: "РАСХОД",
                        value: String(format: "%.1f", currentCar.fuelConsumption),
                        unit: currentCar.speedOBD == 0 ? "L/H" : "L/100"
                    )
                }
                
                Spacer()
            }
            .onReceive(timer) { _ in
                self.simulateCarLife()
            }
        }

    }
}

// Вспомогательная вьюшка для датчиков
struct SmallMetricView: View {
    var label: String
    var value: String
    var unit: String
    var color: Color = .primary // ЗАМЕНИ .white НА .primary
    
    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary) // БЫЛО .gray
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(color) // ОСТАВЛЯЕМ color, НО ПО УМОЛЧАНИЮ ОН .primary
            Text(unit)
                .font(.system(size: 10))
                .foregroundColor(.secondary)
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
