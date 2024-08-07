# MapProject

## Overview

MapProject is a Flutter application that allows users to interact with a map, set markers, and receive notifications when they are near their saved locations. The app features a user-friendly interface with the ability to get the current location, scroll through the map, create markers, and set reminders for specific locations. The app also handles location services permissions and uses live location services.

## Features

- **Current Location:**
  - Users can quickly navigate to their current location on the map.

- **Map Scrolling:**
  - Users can scroll and explore the entire map seamlessly.

- **Marker Creation:**
  - Users can create markers for specific locations on the map, including on long press.

- **Reminders:**
  - Users can set reminders for specific markers.
  - Notifications are triggered when users are within 100 meters of a saved marker.

- **Zoom:**
  - Users can zoom in and out of the map.

## Screenshots

<img src="https://github.com/user-attachments/assets/21a4f765-8ace-4e8c-9a77-856a57ac0e9f" alt="Screenshot" height="400">
<img src="https://github.com/user-attachments/assets/d123b7a1-0559-425d-a1ce-9f5a5659e62b" alt="Screenshot" height="400">
<img src="https://github.com/user-attachments/assets/888e4045-0efc-440f-afe1-924dac965749" alt="Screenshot" height="400">
<img src="https://github.com/user-attachments/assets/1026894a-7d59-42fb-82a6-68fcb5f5bd5c" alt="Screenshot" height="400">
<img src="https://github.com/user-attachments/assets/ffbc6549-8d1f-4a4e-802a-1412ee82ec58" alt="Screenshot" height="400">
<img src="https://github.com/user-attachments/assets/14183dfc-acec-44dc-a9c5-ea984e21d43e" alt="Screenshot" height="400">
<img src="https://github.com/user-attachments/assets/5c0f46c3-f90d-405e-a95a-0cdfbd991550" alt="Screenshot" height="400">

## Dependencies

- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- [flutter_datetime_picker_plus](https://pub.dev/packages/flutter_datetime_picker_plus)
- [permission_handler](https://pub.dev/packages/permission_handler)
- [get](https://pub.dev/packages/get)
- [location](https://pub.dev/packages/location)
- [google_maps_flutter](https://pub.dev/packages/google_maps_flutter)
- [geolocator](https://pub.dev/packages/geolocator)
- [shared_preferences](https://pub.dev/packages/shared_preferences)
- [fluttertoast](https://pub.dev/packages/fluttertoast)
- [intl](https://pub.dev/packages/intl)

## Getting Started

1. Clone the repository:

    ```bash
    git clone https://github.com/your-username/mapproject.git
    ```

2. Install dependencies:

    ```bash
    flutter pub get
    ```

3. Add your Google Maps API key:

    For Android, add your API key in the `android/app/src/main/AndroidManifest.xml` file:

    ```xml
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="your_api_key"/>
    ```

    For iOS, add your API key in the `ios/Runner/AppDelegate.swift` file:

    ```swift
        GMSServices.provideAPIKey("your_api_key")
    ```

4. Run the app:

    ```bash
    flutter run
    ```

## Contributing

Contributions are welcome! If you find any issues or have suggestions, feel free to open an issue or create a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Feel free to customize the sections according to your specific project details and needs. Don't forget to update the placeholders like `your-username` and `your_api_key`. Add additional sections or details if necessary.

Feedback and Suggestions are Welcome!
I'd love to hear your thoughts on this design. Your feedback and suggestions are highly valuable as I continue refining and improving this concept. Let me know what you think!
