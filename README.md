# CombineDitto

`pod "CombineDitto"` is an extension methods library for `pod "DittoSwift"` that seamlessly works with Apple's `Combine` library. This library also includes an Example To Do List Application

[![Ditto logo](https://www.ditto.live/_ipx/w_96,q_75/%2Flogos%2Flogo.png?url=%2Flogos%2Flogo.png&w=96&q=75)](https://www.ditto.live/)

[![Version](https://img.shields.io/cocoapods/v/CombineDitto.svg?style=flat)](https://cocoapods.org/pods/CombineDitto)
[![License](https://img.shields.io/cocoapods/l/CombineDitto.svg?style=flat)](https://cocoapods.org/pods/CombineDitto)
[![Platform](https://img.shields.io/cocoapods/p/CombineDitto.svg?style=flat)](https://cocoapods.org/pods/CombineDitto)
[![Platform](https://img.shields.io/cocoapods/p/CombineDitto.svg?style=flat)](https://cocoapods.org/pods/CombineDitto)

# 🚚 Moved - Now in DittoSwift!

This Ditto extension library is now obsolete. [DittoSwift version 1.1.1](https://docs.ditto.live/changelog)
and higher now include very similar APIs for the publishers that originally lived in this project.

Now, you can use `liveQueryPublisher()` directly:

```swift
import DittoSwift

ditto.store.collection("products")
  .find("categoryName == '\(categoryName)'")
  .liveQueryPublisher()
```

# Legacy documentation

## Running the example app


<img src="https://media.giphy.com/media/2yRCXzR1cH8WEypLbd/giphy.gif"/>

1. To run the example project, clone the repo, and run `pod install` from the Example directory first.
2. The example app is a to do list application and will require a Ditto license token. This file is ignored from the source control, you'll need to add it in.

## Requirements

- iOS 13.0 or higher
- `DittoSwift` 1.0.4 or higher
- A Ditto license token

## Installation

CombineDitto is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CombineDitto'
```

or if you want to use it from this source:

```ruby
pod 'CombineDitto' :git => 'https://github.com/getditto/CombineDitto.git', :branch => 'master'
```

## Quick Start

1. Import `DittoSwift` and `CombineDitto`

```swift
import DittoSwift
import CombineDitto
```

2. Create a query an get a publisher:

```swift
@Published var snapshot: Snapshot = ditto.store["todos"].findAll().publisher()
```

3. Or you can publish a single query:

```swift
@Published var snapshot: SingleSnapshot = ditto.store["todos"].findByID("123abc").publisher()
```

## Usage with SwiftUI

1. Construct a Ditto instance. Usually this can be in the `AppDelegate.swift` code like so:

```swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static var ditto: Ditto!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        Self.ditto = Ditto()
        Self.ditto.setAccessLicense("YOUR LICENSE TOKEN HERE")
        Self.ditto.startSync()

        return true
    }

}

2. Create a data source:

class DataSource: ObservableObject {

    @Published var documents = [DittoDocument]()
    var cancellables = Set<AnyCancellable>()

    private let todoPublisher = AppDelegate.ditto.store["todos"].findAll().publisher()
    private let faker = Faker()

    func start() {
        todoPublisher
            .map({ (documents, event) in
                return documents
            })
            .assign(to: &$todos)
    }
}
```

3. In your content view's `onAppear` handler, call `start()` to start the liveQuery and bind to the data!

```swift
struct ContentView: View {

    @ObservedObject var dataSource: DataSource

    var body: some View {
        NavigationView {
          ForEach(dataSource.documents, id: \.id) { document in
            Text(document["text"].stringValue)
          }
        }
    }.onAppear(perform: {
        dataSource.start()
    })
}
```

## Author

[www.ditto.live](https://ditto.live)

## License

CombineDitto is available under the MIT license. See the LICENSE file for more info.
