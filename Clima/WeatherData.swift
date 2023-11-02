// Decodable çözülebilirlik anlamı taşıyor.
import Foundation

struct WeatherData: Codable{
    let name:String
    let main:Main
    var weather:[Weather]
}
struct Main:Codable{
    let temp:Double
}
struct Weather:Codable{
    let description:String
    let id:Int
}
