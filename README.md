# ForecastManager
ForecastManger is simple library for the [Forecast Weather API](http://www.developer.forecast.com)
Features:
- Closure requests
- Support for languages, units, exlusions

## Usage

Get API Key from [Forecast API](http://www.developer.forecast.com)

Create API manager with your API Key
```swift
let manager = Forecast("API_KEY")
```

Example 1
```swift
 manager.fetchForecastWithDate(NSDate(), latitude: 51.514512, longitude: 0.123845, success: { response in
            println(response)
        }) { error in
            println(error)
        }
```

Example 2
```swift
 manager.fetchForecastWithTime("2014/10/21 16:36", latitude: 51.514512, longitude: 0.123845,
            success: { response in
                println(response)
            }, failure : { error in
                println(error)
        })
```

Example 3
```swift
 manager.fetchForecastWithDate(NSDate(), latitude: 51.514512, longitude: 0.123845, exclusions: [.Hourly, .Daily], units: .SI, language: .PL, success: { response in
            println(response)
        }) { error  in
            println(error)
        }
```

## TODO

- [ ] Tests
- [ ] Full comments
- [ ] Caching
- [ ] Delegate requests
- [ ] Example project
