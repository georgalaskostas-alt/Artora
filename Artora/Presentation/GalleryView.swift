import SwiftUI
import UIKit

struct GalleryView: View {
    @EnvironmentObject private var gallery: GalleryStore
    @EnvironmentObject private var progress: ProgressStore
    @State private var pending: GalleryArtwork?
    @State private var failed = false
    private var greek: Bool { progress.preferredLanguage == .greek }
    var body: some View {
        ScrollView {
            if gallery.loadFailed { Text(greek ? "Ορισμένα έργα δεν φορτώθηκαν." : "Some artworks could not be loaded.").font(.caption) }
            if gallery.artworks.isEmpty {
                ContentUnavailableView(greek ? "Η συλλογή σου" : "Your collection", systemImage: "photo.on.rectangle", description: Text(greek ? "Αποθήκευσε ένα σχέδιο από τον έλεγχο ή το εργαστήριο." : "Save a drawing from Review or Studio."))
            }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                ForEach(gallery.artworks) { item in
                    VStack(alignment: .leading) {
                        NavigationLink {
                            ScrollView {
                                if let image = UIImage(data: item.jpeg) { Image(uiImage: image).resizable().scaledToFit() }
                                Text(item.created, style: .date)
                            }.padding().navigationTitle(item.title)
                        } label: {
                            if let image = UIImage(data: item.jpeg) {
                                Image(uiImage: image).resizable().scaledToFit().frame(height: 140).frame(maxWidth: .infinity)
                            } else { Image(systemName: "photo").frame(height: 140) }
                        }.buttonStyle(.plain)
                        Text(item.title).font(.headline)
                        Text(item.created, style: .date).font(.caption)
                        Button(role: .destructive) { pending = item } label: { Label(greek ? "Διαγραφή" : "Delete", systemImage: "trash").font(.caption) }
                    }.padding(12).background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
                }
            }.padding()
        }.navigationTitle(greek ? "Συλλογή" : "Gallery")
        .confirmationDialog(greek ? "Διαγραφή έργου;" : "Delete artwork?", isPresented: Binding(get: { pending != nil }, set: { if !$0 { pending = nil } }), titleVisibility: .visible) {
            Button(greek ? "Διαγραφή" : "Delete", role: .destructive) {
                if let item = pending { do { try gallery.remove(item) } catch { failed = true } }
                pending = nil
            }
        }
        .alert(greek ? "Αποτυχία διαγραφής" : "Deletion failed", isPresented: $failed) { Button("OK", role: .cancel) {} }
    }
}
