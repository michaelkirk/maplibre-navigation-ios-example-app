//
//  ViewController.swift
//  MapLibreNavigationExampleUIKitApp
//
//  Created by Michael Kirk on 5/14/24.
//

import UIKit
import MapboxDirections
import MapboxNavigation
import MapLibre
import MapboxCoreNavigation

class ViewController: UIViewController {
  override func loadView() {
    view = NavigationMapView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .purple
    let label = UILabel()
    label.text = "Hello World"
    view.addSubview(label)
    label.centerInSuperview()
    label.backgroundColor = .yellow

    getRoute() { route in
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        let simulatedLocationManager = SimulatedLocationManager(route: route)
        simulatedLocationManager.speedMultiplier = 5
        let vc = MapboxNavigation.NavigationViewController(for: route, locationManager: simulatedLocationManager)
        self.present(vc, animated: true)
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

extension UIView {
  func centerInSuperview() {
    guard let parent = self.superview else {
      assertionFailure("superview was unexpectedly nil");
      return
    }
    self.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
      self.centerYAnchor.constraint(equalTo: parent.centerYAnchor)
    ])
  }
  func pinToSuperview() {
    guard let parent = self.superview else {
      assertionFailure("superview was unexpectedly nil");
      return
    }
    self.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
      self.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
      self.topAnchor.constraint(equalTo: parent.topAnchor),
      self.bottomAnchor.constraint(equalTo: parent.bottomAnchor)
    ])
  }
}

