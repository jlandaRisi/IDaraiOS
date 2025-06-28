# ConnectivityModule

The `ConnectivityModule` provides functionality to monitor and retrieve the current network connectivity status. It is designed to be modular, scalable, and easy to integrate into any project.

## Features
- Detects if the device is connected to a network.
- Identifies the type of connection: WiFi, Cellular, or Other.
- Provides a ViewModel for easy integration with UI frameworks.

## Architecture
The module follows the MVVM architecture and adheres to SOLID principles and Clean Code practices.

## Components

### Models
- `ConnectivityStatus`: Enum representing the connectivity status and type.

### Protocols
- `ConnectivityServiceProtocol`: Protocol defining the interface for connectivity services.

### Services
- `NetworkReachabilityService`: Implementation of `ConnectivityServiceProtocol` using the `Network` framework.

### ViewModel
- `ConnectivityViewModel`: Exposes the connectivity status to the UI.

## Usage

1. Create an instance of `NetworkReachabilityService`:

    ```swift
    let service = NetworkReachabilityService()
    ```

2. Create an instance of `ConnectivityViewModel`:

    ```swift
    let viewModel = ConnectivityViewModel(service: service)
    ```

3. Start monitoring:

    ```swift
    viewModel.startMonitoring()
    ```

4. Observe the `status` property in your UI:

    ```swift
    viewModel.$status.sink { status in
        print("Current status: \(status)")
    }
    ```

## Unit Tests
Unit tests are provided in `ConnectivityServiceTests.swift` to ensure the correctness of the module.
