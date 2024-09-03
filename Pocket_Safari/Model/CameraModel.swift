import Foundation
import AVFoundation
import CoreImage
import Observation

class CameraModel: NSObject {
    
    // Necessary to setup camera functioning
    private let captureSession = AVCaptureSession()
    private var input: AVCaptureDeviceInput? // Make this optional
    private let videoOutput = AVCaptureVideoDataOutput() // Initialize this directly
    private let systemCamera = AVCaptureDevice.default(for: .video)
    private let sessionQueue = DispatchQueue(label: "video.preview.session")
    private var addStream: ((CGImage) -> Void)?
    
    private var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            var isAuthorized = status == .authorized
            
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            
            return isAuthorized
        }
    }
    
    lazy var stream: AsyncStream<CGImage> = {
        AsyncStream { continuation in
            addStream = { cgImage in
                continuation.yield(cgImage)
            }
        }
    }()
    
    override init() {
        super.init()
        
        Task {
            await configureSession()
            await startSession()
        }
    }
    
    private func configureSession() async {
        guard await isAuthorized,
              let systemCamera = systemCamera,
              let deviceInput = try? AVCaptureDeviceInput(device: systemCamera) else { return }
        
        captureSession.beginConfiguration()
        
        defer {
            self.captureSession.commitConfiguration()
        }
        
        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        
        guard captureSession.canAddInput(deviceInput) else {
            print("Unable to add device input to capture session.")
            return
        }
        
        guard captureSession.canAddOutput(videoOutput) else {
            print("Unable to add video output to capture session.")
            return
        }
        
        captureSession.addInput(deviceInput)
        captureSession.addOutput(videoOutput)
        
        // Save the input to the property for use in the delegate method
        self.input = deviceInput
    }
    
    private func startSession() async {
        guard await isAuthorized else { return }
        captureSession.startRunning()
    }
}

extension CameraModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let currentFrame = sampleBuffer.cgImage else { return }
        addStream?(currentFrame)
    }
}

@Observable
class ViewModel {
    var currFrame: CGImage?
    private let cameraManager = CameraModel()
    
    init() {
        Task {
            await handleCameraPreviews()
        }
    }
    
    func handleCameraPreviews() async {
        for await image in cameraManager.stream {
            Task { @MainActor in
                currFrame = image
            }
        }
    }
}
