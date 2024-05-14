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
      if let route = route {
        MENavigationViewController(route: route.value)
      } else {
        MENavigationMapView()
      }
    }.onAppear() {
      DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
        getRoute() { route in
          self.route = IdentifiableValue(id: 1, value: route)
        }
      }
    }
  }
}

func getRoute(completion: @escaping (Route) -> Void) {
  let waypoints = [
    // FixtureData.places[.zeitgeist].location.asCLLocation,
    CLLocation(latitude: 47.599091, longitude: -122.331856),
    // FixtureData.places[.realfine].location.asCLLocation,
    CLLocation(latitude: 47.563412, longitude: -122.378248)
  ].map { Waypoint(location: $0) }

  let options = NavigationRouteOptions(
    waypoints: waypoints, profileIdentifier: .automobileAvoidingTraffic)
  options.shapeFormat = .polyline6
  options.distanceMeasurementSystem = .metric
  options.attributeOptions = []

  Directions.shared.calculate(options) { (waypoints, routes, error) in
    guard let route = routes?.first else {
      assertionFailure("no route. error: \(String(describing: error))")
      return
    }
    completion(route)
  }
}

struct MENavigationMapView: UIViewRepresentable {
  typealias UIViewType = NavigationMapView

  func makeUIView(context: Context) -> MapboxNavigation.NavigationMapView {
    let mapView = NavigationMapView(frame: .zero)
    return mapView
  }
  
  func updateUIView(_ uiView: MapboxNavigation.NavigationMapView, context: Context) {
    print("in updateUIView")
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
