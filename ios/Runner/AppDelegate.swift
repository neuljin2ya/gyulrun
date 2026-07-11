import Flutter
import Photos
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    let channel = FlutterMethodChannel(
      name: "gyulrun/gallery",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
    channel.setMethodCallHandler { call, result in
      guard call.method == "saveImage" else {
        result(FlutterMethodNotImplemented)
        return
      }

      guard
        let bytes = call.arguments as? FlutterStandardTypedData,
        let image = UIImage(data: bytes.data)
      else {
        result(FlutterError(code: "invalid_image", message: "Invalid image bytes", details: nil))
        return
      }

      self.saveImageToPhotoLibrary(image, result: result)
    }
  }

  private func saveImageToPhotoLibrary(_ image: UIImage, result: @escaping FlutterResult) {
    if #available(iOS 14, *) {
      PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
        self.performPhotoSaveIfAllowed(
          status == .authorized || status == .limited,
          image: image,
          result: result
        )
      }
    } else {
      PHPhotoLibrary.requestAuthorization { status in
        self.performPhotoSaveIfAllowed(
          status == .authorized,
          image: image,
          result: result
        )
      }
    }
  }

  private func performPhotoSaveIfAllowed(
    _ allowed: Bool,
    image: UIImage,
    result: @escaping FlutterResult
  ) {
    guard allowed else {
      DispatchQueue.main.async {
        result(false)
      }
      return
    }

    PHPhotoLibrary.shared().performChanges({
      PHAssetChangeRequest.creationRequestForAsset(from: image)
    }) { success, error in
      DispatchQueue.main.async {
        if let error = error {
          result(FlutterError(code: "save_failed", message: error.localizedDescription, details: nil))
        } else {
          result(success)
        }
      }
    }
  }
}
