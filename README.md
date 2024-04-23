# geo_agency_mobile

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## To run Integration Tests

flutter drive  --driver=e2e/web_driver.dart --target=e2e/login_web_test.dart -d chrome 

## Start Chromedriver before Integration Tests for Web App

chromedriver --port=4444

## To run Unit Tests

flutter test test/unit/login_repo_test.dart