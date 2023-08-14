<br/>
<div align="center">
  <a href="https://github.com/kwsong0113/turing-machine-app">
    <img src="https://github.com/kwsong0113/turing-machine-app/assets/53707540/81923c1d-9867-4d37-a482-799dfd5c3be6" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Turing Machine Game</h3>

  <p align="center">
    An iOS app for playing Turing Machine game 🎲
  </p>
</div>

---

**API Documentation**: [Swagger UI](http://43.200.120.78/docs) / [Redoc](http://43.200.120.78/redoc)

**Server Repository**: [kwsong0113/turing-machine-api](https://github.com/kwsong0113/turing-machine-api)

---

## About

This project brings [Turing Machine game](https://www.scorpionmasque.com/en/turingmachine) - a competitive deduction board game where players strive to decipher a hidden code by skillfully interacting with a proto-computer - to your iOS device. It addresses the inconvenience of setting up the complex board game with many cards and sheets by simulating the game's components and mechanics within the app. Players can enjoy engaging in the game with others in real-time, facilitated by the [server](https://github.com/kwsong0113/turing-machine-api).

## Demo
<div align="center">
  <img src="https://github.com/kwsong0113/turing-machine-app/assets/53707540/054f4be6-44b6-48e5-8744-a9ecbccd0d2f" width="300" />
</div>

## Built With

This iOS app is built with MVVM architecture using [Swift](https://github.com/apple/swift) and SwiftUI.

- [CocoaPods](https://github.com/CocoaPods/CocoaPods) - Dependency Manager
- [SwiftLint](https://github.com/realm/SwiftLint) / [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) - Swift Code Style and Formatting
- [Inject](https://github.com/krzysztofzablocki/Inject) - Hot Reloading
- [Alamofire](https://github.com/Alamofire/Alamofire) - HTTP Networking
- WebSocket - Real-time Interactive Communication
- Xcode Cloud - Continuous Deployment

## Getting Started

### Installation

```shell
pod install
```

### Enable Hot Reloading

- View [Inject](https://github.com/krzysztofzablocki/Inject) and [InjectionIII](https://github.com/johnno1962/InjectionIII)

### Environment Variables

At `TuringMachine/secret.plist`

- `WEBSOCKET_ENDPOINT_URL` - ws://...
- `API_ENDPOINT_URL` - http://... or https://...

## License

This project is licensed under the terms of the MIT license.
