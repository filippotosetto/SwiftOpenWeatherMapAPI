
Pod::Spec.new do |s|

  s.name         = "SwiftOpenWeatherMapAPI"
  s.version      = "0.0.7"
  s.summary      = "Swift Open Weather Map API is a wrapper around http://openweathermap.org."

  s.homepage     = "http://github.com/filippotosetto/SwiftOpenWeatherMapAPI"
  s.license      = { :type => 'MIT', :file => 'LICENSE'}
  s.author       = { "Filippo Tosetto" => "filippo.tosetto@gmail.com" }

  s.requires_arc = true

  s.ios.deployment_target = '8.0'
  s.watchos.deployment_target = '2.0'

  s.source     = { :git => "https://github.com/filippotosetto/SwiftOpenWeatherMapAPI.git", :tag => s.version }
  s.source_files = "API/*.swift"

  s.dependency 'Alamofire', '~> 2.0'
  s.dependency 'SwiftyJSON', '~> 2.3.0'

  s.requires_arc = true

end
