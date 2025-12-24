import Foundation
import CoreLocation

class LocationService: NSObject, ObservableObject {
    static let shared = LocationService()
    
    @Published var currentLocation: Location?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var errorMessage: String?
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    override private init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdating() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdating() {
        locationManager.stopUpdatingLocation()
    }
    
    func getCurrentLocation() async throws -> Location {
        return try await withCheckedThrowingContinuation { continuation in
            if let location = locationManager.location {
                geocodeLocation(location) { result in
                    switch result {
                    case .success(let location):
                        continuation.resume(returning: location)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            } else {
                continuation.resume(throwing: LocationError.locationNotAvailable)
            }
        }
    }
    
    private func geocodeLocation(_ clLocation: CLLocation, completion: @escaping (Result<Location, Error>) -> Void) {
        geocoder.reverseGeocodeLocation(clLocation) { placemarks, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let placemark = placemarks?.first else {
                completion(.failure(LocationError.geocodingFailed))
                return
            }
            
            let location = Location(
                latitude: clLocation.coordinate.latitude,
                longitude: clLocation.coordinate.longitude,
                city: placemark.locality,
                state: placemark.administrativeArea
            )
            
            completion(.success(location))
        }
    }
    
    func calculateDistance(from: Location, to: Location) -> Double {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        
        // Distance in meters, convert to miles
        return fromLocation.distance(from: toLocation) / 1609.34
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdating()
        case .denied, .restricted:
            errorMessage = "Location access denied. Please enable in Settings."
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let clLocation = locations.last else { return }
        
        geocodeLocation(clLocation) { [weak self] result in
            if case .success(let location) = result {
                DispatchQueue.main.async {
                    self?.currentLocation = location
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = error.localizedDescription
    }
}

enum LocationError: LocalizedError {
    case locationNotAvailable
    case geocodingFailed
    case permissionDenied
    
    var errorDescription: String? {
        switch self {
        case .locationNotAvailable:
            return "Unable to get current location"
        case .geocodingFailed:
            return "Unable to determine address"
        case .permissionDenied:
            return "Location permission denied"
        }
    }
}
