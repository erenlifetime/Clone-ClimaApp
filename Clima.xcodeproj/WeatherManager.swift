import UIKit
import CoreLocation
// Start the task
// neden start demiyor resume diyor
// yeni bir görev oluşturduğumuzda askıya alınmış bir durumda başlar. Yani görevi başlatmak için bu yöntemi çağırmanız gerekir.
// Dökümantasyon okumanın faydaları
protocol WeatherManagerDelegate {
    func didUpdateManager(_ weatherManager:WeatherManager,weather:WeatherModul)
    func didFailWithError(error: Error)
}
struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=c1851c5536455c248b55a1a652d6ec2f&units=metric"
    var delegate:WeatherManagerDelegate?
    func fetchWeather(cityName:String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with:urlString)
    }
    func fetchWeather(latitude: CLLocationDegrees, longitute: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitute)"
        performRequest(with: urlString)
    }
    func performRequest(with urlString:String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){(data,response,error)in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let weather = self.parseJson(weatherData: safeData){
                        self.delegate?.didUpdateManager(self, weather: weather)
                    }
                }
                task.resume()
            }
        }
    }
        func parseJson(weatherData: Data) -> WeatherModul? {
                let decoder = JSONDecoder()
                do{
                    let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
                let id = decodedData.weather[0].id
                let temp = decodedData.main.temp
                let name = decodedData.name
                let weather = WeatherModul(conditionId: id, temperature: temp, cityName: name)
                    return weather
                }catch{
                    delegate?.didFailWithError(error: error)
                    return nil
                }
            }
    }
