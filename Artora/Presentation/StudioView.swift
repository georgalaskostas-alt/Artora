import SwiftUI
import PencilKit

struct StudioView: View {
    @EnvironmentObject private var progress: ProgressStore
    @State private var canvas = PKCanvasView()
    @State private var color: Color = .black
    @State private var width = 4.0
    @State private var eraser = false
    @State private var showClear = false
    @State private var status = ""
    private var greek: Bool { progress.preferredLanguage == .greek }
    private var file: URL { URL.documentsDirectory.appendingPathComponent("studio.pkdrawing") }
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                ColorPicker(greek ? "Χρώμα" : "Color", selection: $color, supportsOpacity: false)
                Button { eraser.toggle() } label: { Image(systemName: eraser ? "eraser.fill" : "eraser") }
                Button { canvas.undoManager?.undo() } label: { Image(systemName:"arrow.uturn.backward") }
                Button { canvas.undoManager?.redo() } label: { Image(systemName:"arrow.uturn.forward") }
                Button { showClear = true } label: { Image(systemName:"trash") }
            }
            Slider(value: $width, in: 1...20).accessibilityLabel(greek ? "Πάχος" : "Stroke width")
            StudioCanvas(canvas: canvas, color: color, width: width, eraser: eraser)
                .clipShape(RoundedRectangle(cornerRadius: 18))
            Button(greek ? "Αποθήκευση" : "Save drawing") { save() }.buttonStyle(.borderedProminent)
            Text(status).font(.caption)
        }
        .padding()
        .navigationTitle(greek ? "Εργαστήριο" : "Studio")
        .onAppear { if let data = try? Data(contentsOf: file), let drawing = try? PKDrawing(data: data) { canvas.drawing = drawing } }
        .confirmationDialog(greek ? "Διαγραφή σχεδίου;" : "Clear drawing?", isPresented: $showClear) {
            Button(greek ? "Διαγραφή" : "Clear", role: .destructive) { canvas.drawing = PKDrawing(); save() }
        }
    }
    private func save() {
        do { try canvas.drawing.dataRepresentation().write(to: file, options: .atomic); status = greek ? "Αποθηκεύτηκε" : "Saved" }
        catch { status = greek ? "Αποτυχία αποθήκευσης" : "Save failed" }
    }
}
private struct StudioCanvas: UIViewRepresentable {
    let canvas: PKCanvasView
    let color: Color
    let width: Double
    let eraser: Bool
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.backgroundColor = .white
        canvas.isOpaque = true
        canvas.drawingPolicy = .anyInput
        return canvas
    }
    func updateUIView(_ view: PKCanvasView, context: Context) {
        if eraser { view.tool = PKEraserTool(.vector) }
        else { view.tool = PKInkingTool(.pen, color: UIColor(color), width: CGFloat(width)) }
    }
}
