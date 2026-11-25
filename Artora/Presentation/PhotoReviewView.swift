import SwiftUI
import PhotosUI
import UIKit
import Vision
import CoreImage

struct PhotoReviewView: View {
    @EnvironmentObject private var progress: ProgressStore
    @State private var item: PhotosPickerItem?
    @State private var photo: UIImage?
    @State private var corrected: UIImage?
    @State private var camera = false
    @State private var message = ""
    private var greek: Bool { progress.preferredLanguage == .greek }
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(greek ? "Φωτογράφισε το σχέδιό σου" : "Review your paper drawing").font(.title2.bold())
                if let image = corrected ?? photo {
                    Image(uiImage: image).resizable().scaledToFit().clipShape(RoundedRectangle(cornerRadius: 16))
                } else {
                    Image(systemName:"doc.viewfinder").font(.system(size: 80)).foregroundStyle(.secondary)
                }
                PhotosPicker(selection: $item, matching: .images) { Label(greek ? "Επιλογή φωτογραφίας" : "Choose photo", systemImage:"photo") }
                    .buttonStyle(.borderedProminent)
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    Button { camera = true } label: { Label(greek ? "Κάμερα" : "Camera", systemImage:"camera") }.buttonStyle(.bordered)
                }
                if let image = corrected ?? photo { SketchFeedbackView(image: image, greek: greek).id(ObjectIdentifier(image)) }
                if photo != nil {
                    Button(greek ? "Εντοπισμός χαρτιού" : "Detect paper") { detectPaper() }.buttonStyle(.bordered)
                    Button(greek ? "Αφαίρεση φωτογραφίας" : "Remove photo", role: .destructive) { photo = nil; corrected = nil; item = nil; message = "" }
                }
                Text(message).font(.subheadline)
                Text(greek ? "Η εικόνα παραμένει στη συσκευή. Η ανίχνευση χαρτιού δεν αξιολογεί την καλλιτεχνική ποιότητα." : "Your image stays on this device. Paper detection does not grade artistic quality.").font(.footnote).foregroundStyle(.secondary)
            }.padding()
        }
        .navigationTitle(greek ? "Έλεγχος σχεδίου" : "Drawing review")
        .task(id: item) {
            guard let selected = item else { return }
            do {
                if let data = try await selected.loadTransferable(type: Data.self), let image = UIImage(data: data), !Task.isCancelled {
                    photo = image; corrected = nil; message = ""
                }
            } catch { if !Task.isCancelled { message = greek ? "Αποτυχία εισαγωγής" : "Import failed" } }
        }
        .sheet(isPresented: $camera) { CameraCapture { image in photo = image; corrected = nil; message = "" } }
    }
    private func detectPaper() {
        guard let photo else { return }
        let format = UIGraphicsImageRendererFormat(); format.scale = 1
        let ratio = min(1, 1600 / max(photo.size.width, photo.size.height))
        let size = CGSize(width: photo.size.width * ratio, height: photo.size.height * ratio)
        let normalized = UIGraphicsImageRenderer(size: size, format: format).image { _ in photo.draw(in: CGRect(origin:.zero,size:size)) }
        guard let cg = normalized.cgImage else { return }
        let request = VNDetectRectanglesRequest()
        request.maximumObservations = 1
        request.minimumConfidence = 0.6
        request.minimumSize = 0.25
        do {
            try VNImageRequestHandler(cgImage: cg).perform([request])
            guard let rect = request.results?.first else { message = greek ? "Δεν εντοπίστηκε καθαρό περίγραμμα χαρτιού." : "No clear paper boundary detected."; return }
            let input = CIImage(cgImage: cg)
            func point(_ p: CGPoint) -> CIVector { CIVector(x:p.x * input.extent.width,y:p.y * input.extent.height) }
            let output = input.applyingFilter("CIPerspectiveCorrection", parameters: ["inputTopLeft":point(rect.topLeft),"inputTopRight":point(rect.topRight),"inputBottomLeft":point(rect.bottomLeft),"inputBottomRight":point(rect.bottomRight)])
            if let result = CIContext().createCGImage(output, from: output.extent) {
                corrected = UIImage(cgImage:result)
                message = greek ? "Διορθώθηκε η προοπτική. Έλεγξε ότι το χαρτί εντοπίστηκε σωστά." : "Perspective corrected. Check that the paper was detected correctly."
            }
        } catch { message = greek ? "Αποτυχία ανίχνευσης" : "Detection failed" }
    }
}
private struct CameraCapture: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    let onImage: (UIImage) -> Void
    func makeCoordinator() -> Coordinator { Coordinator(parent:self) }
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    func updateUIViewController(_ controller: UIImagePickerController, context: Context) {}
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraCapture
        init(parent: CameraCapture) { self.parent = parent }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { parent.dismiss() }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey:Any]) {
            if let image = info[.originalImage] as? UIImage { parent.onImage(image) }
            parent.dismiss()
        }
    }
}
