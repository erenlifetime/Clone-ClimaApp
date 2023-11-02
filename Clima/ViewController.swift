
import UIKit
import CoreLocation

class WeatherViewController: UIViewController{
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
        override func viewDidLoad() {
            super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        }
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}
    // kullanıcı search kısmıyla ürünü araybilecek
    // kullanıcı Ara buttonuna tıkladığında istediğe sayfaya gidecek
    //MARK - UITextFieldDelegate
    
    extension WeatherViewController:UITextFieldDelegate{
    //MARK - WeathermanagerDelegate
        @IBAction func searchPressed(_ sender: UIButton) {
            searchTextField.endEditing(true)
        }
        // kullanıcı klavyedeki return tuşuna bastığında tetikleyecek kod
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            searchTextField.endEditing(true)
            return true
            
        }
        
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            if textField.text != ""{
                return true
            }else{
                searchTextField.placeholder = "Type Something"
                return false
            }
        }
        func textFieldDidEndEditing(_ textField: UITextField) {
            if let city = searchTextField.text{
                weatherManager.fetchWeather(cityName: city)
            }
            searchTextField.text = ""
        }
    }
extension WeatherViewController: WeatherManagerDelegate{
    func didUpdateManager(_ weatherManager: WeatherManager, weather: WeatherModul) {
        DispatchQueue.main.async{
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}
extension WeatherViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print(lat)
            print(lon)
        }
    }
    func locationManager(_ manager:CLLocationManager,didFailWithError error:Error){
        print(error)
    }
}
