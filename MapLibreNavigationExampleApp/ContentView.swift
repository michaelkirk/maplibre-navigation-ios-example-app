//
//  ContentView.swift
//  MapLibreNavigationExampleApp
//
//  Created by Michael Kirk on 5/14/24.
//

import SwiftUI
import MapboxDirections
import MapboxNavigation
import MapLibre
import MapboxCoreNavigation

struct IdentifiableValue<T>: Identifiable {
  let id: Int
  let value: T
}

struct ContentView: View {
  @State var route: IdentifiableValue<Route>?

  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
    .sheet(item: $route) { item in
      MENavigationViewController(route: item.value)
    }.onAppear() {
      // route = getRoute()
    }
  }
}

struct MENavigationViewController: UIViewControllerRepresentable {
  typealias UIViewControllerType = MapboxNavigation.NavigationViewController

  let route: Route

  func makeUIViewController(context: Context) -> Self.UIViewControllerType {
    let simulatedLocationManager = SimulatedLocationManager(route: route)
    simulatedLocationManager.speedMultiplier = 5
    let vc = MapboxNavigation.NavigationViewController(for: route, locationManager: simulatedLocationManager)
    return vc
  }

  func updateUIViewController(_ uiViewController: Self.UIViewControllerType, context: Context) {
    // Update the view controller if needed
  }
}

#Preview {
  ContentView()
}
