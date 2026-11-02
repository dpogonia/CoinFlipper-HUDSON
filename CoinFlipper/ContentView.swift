import SwiftUI

// Класс монеты, соответствующий ObservableObject
class Coin: ObservableObject, Hashable {
    static func == (lhs: Coin, rhs: Coin) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Уникальный идентификатор для соответствия протоколу Hashable
    let id = UUID()
    
    // Название символа для использования в качестве изображения
    let iconName: String
    
    // Угол поворота монеты
    @Published var angle: Double = 0
    
    init(iconName: String) {
        self.iconName = iconName
    }
}

// Представление одной монеты
struct CoinView: View {
    // Монета, которую отображаем
    @ObservedObject var coin: Coin
    
    var body: some View {
        Image(systemName: coin.iconName)
            .font(.system(size: 100))
            .foregroundColor(.blue)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.white, lineWidth: 4)
            )
            .shadow(radius: 10)
            .rotationEffect(Angle(degrees: coin.angle)) // Применяем поворот
            .animation(.spring(response: 0.5, dampingFraction: 0.75), value: coin.angle) // Анимируем поворот
            .onTapGesture {
                // При касании поворачиваем монету
                withAnimation {
                    coin.angle += 180
                }
            }
    }
}

// Главное представление
struct ContentView: View {
    // Массив монет
    let coins: [Coin] = [
        Coin(iconName: "dollarsign.circle"),
        Coin(iconName: "eurosign.circle"),
        Coin(iconName: "yensign.circle"),
        Coin(iconName: "sterlingsign.circle"),
        Coin(iconName: "rublesign.circle"),
        Coin(iconName: "bitcoinsign.circle")
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                ForEach(coins, id: \.id) { coin in
                    CoinView(coin: coin)
                }
            }
        }
    }
}
