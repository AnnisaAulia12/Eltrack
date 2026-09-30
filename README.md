# Eltrack

Eltrack is a Flutter-based mobile application designed to help users track and manage environmental activities through location-based features, maps, news, and image-based scanning.

## Features

* 📍 Location-based features
* 🗺️ Google Maps integration
* 📰 Environmental news through News API
* 📷 Image/scanner feature
* 🗃️ Data management using the application database
* 🌱 Environmental activity tracking

## Tech Stack

* Flutter & Dart
* Google Maps API
* News API
* Database
* Android Studio

---

## Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd eltrack_mobile
```

### 2. Install Dependencies

Run:

```bash
flutter pub get
```

### 3. Configure API Keys

Eltrack requires API keys for some of its features.

**Do not put API keys directly into the GitHub repository.**

Create the required local configuration according to the project structure and add your own API keys.

#### Google Maps API

To use the Google Maps feature, you need your own **Google Maps API key**.

Create or obtain your API key through Google Cloud Console and configure the required Maps API services for your Android application.

Replace the local Google Maps API key with your own key.

> Never upload your API key to GitHub.

#### News API

The news feature uses **News API** to retrieve news data.

You need your own News API key and must configure it locally before running the application.

> Never commit your News API key to the repository.

---

## Scanner Feature

The scanner feature is **not yet fully integrated with a live scanning system**.

For the current version, the scanner functionality uses:

* Existing images/photos
* Data that is already available in the database
* The application's existing data structure

Therefore, when testing the scanner feature, use the **provided existing sample photos/data** that are already prepared for the project.

The scanner should currently be considered a **prototype implementation**, rather than a fully integrated real-time scanning system.

### Important

If you want to test the scanner:

1. Make sure the required sample data exists in the database.
2. Use the existing sample photos provided with the project.
3. Make sure the corresponding data is available in the database.
4. Do not expect the scanner to recognize arbitrary new photos as a fully integrated production scanner yet.

---

## API & Configuration Notes

For security reasons, API keys and other credentials are intentionally excluded from this repository.

Before running the application, configure:

* Google Maps API key
* News API key
* Required backend/database configuration

Use your own credentials when setting up the project locally.

---

## Running the Application

Make sure an Android emulator or physical Android device is connected.

Check available devices:

```bash
flutter devices
```

Run the application:

```bash
flutter run
```

Or specify a particular emulator:

```bash
flutter run -d emulator-5554
```

---

## Project Status

Eltrack is currently a **development/prototype project**.

Some features are fully implemented, while other features are still being developed and integrated.

In particular, the scanner functionality currently relies on existing photos and database data and has not yet been fully integrated with a complete real-time scanning system.

---

## Security

Please make sure that the following are **never committed to GitHub**:

* API keys
* Passwords
* Database credentials
* Private tokens
* `.env` files containing secrets
* Other sensitive configuration files

Before pushing changes, check your Git status:

```bash
git status
```

Make sure no files containing private credentials are included in the commit.

---

## Notes for Contributors

When setting up the project on another computer, you may need to provide your own:

* Google Maps API key
* News API key
* Database/backend configuration

The application may not work correctly until these services are configured.

---

## License

This project was created for educational and development purposes.
