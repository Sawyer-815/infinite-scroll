//
//  ModernScrollView.swift
//  InfiniteScroll
//

import SwiftUI

struct Model: Identifiable {
    let id = UUID()
    let text = generateRandomText(range: 1...5)
    
    // MARK: - Utils
    
    private static func generateRandomText(range: ClosedRange<Int>) -> String {
        var result = ""
        for _ in 0..<Int.random(in: range) {
            if let sentence = sentences.randomElement() {
                result += sentence
            }
        }
        return result.trimmingCharacters(in: .whitespaces)
    }
    
    private static let sentences = [
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
        "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
        "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    ]
}

struct ModernScrollView: View {
    
    private enum Size {
        case fixed
        case dynamic
    }
    
    @State private var size: Size = .fixed
    @State private var models: [Model] = []
    @State private var scrollPositionID: String?
    @State private var text: String = ""
    @FocusState private var isFocused
    
    // MARK: - View
    
    var body: some View {
        scrollView
            .safeAreaInset(edge: .bottom) { controls }
            .task { reset() }
    }
    
    // MARK: - Subviews
    
    private var scrollView: some View {
        ScrollView {
            LazyVStack {
                ForEach(models) { model in
                    cell(for: model)
                        .background(Color(from: model.id))
                        .id(model.id.uuidString)
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $scrollPositionID)
        .scrollDismissesKeyboard(.interactively)
        .defaultScrollAnchor(.bottom)
        .onTapGesture {
            isFocused = false
        }
    }
    
    private var controls: some View {
        VStack {
            Picker("Size Mode", selection: $size) {
                Text("Fixed size").tag(Size.fixed)
                Text("Dynamic size").tag(Size.dynamic)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            HStack {
                Button("Add to top") {
                    models.insert(contentsOf: makeModels(3), at: 0)
                }
                Button("Add to bottom") {
                    models.append(contentsOf: makeModels(3))
                }
                Button("Reset") {
                    reset()
                }
            }
            HStack {
                Button {
                    scrollPositionID = models.first?.id.uuidString
                } label: {
                    Image(systemName: "arrow.up")
                }
                Button {
                    scrollPositionID = models.last?.id.uuidString
                } label: {
                    Image(systemName: "arrow.down")
                }
            }
            TextField("Input", text: $text)
                .padding()
                .background(.ultraThinMaterial, in: .capsule)
                .focused($isFocused)
                .padding(.horizontal)
        }
        .padding(.vertical)
        .buttonStyle(.bordered)
        .background(.regularMaterial)
    }
    
    @ViewBuilder
    private func cell(for model: Model) -> some View {
        switch size {
        case .fixed:
            SquareView(color: Color(from: model.id))
        case .dynamic:
            Text(model.text)
                .padding()
                .multilineTextAlignment(.leading)
        }
    }
    
    // MARK: - Private
    
    private func makeModels(_ count: Int) -> [Model] {
        (0..<count).map { _ in Model() }
    }
    
    private func reset() {
        models = makeModels(3)
    }
    
}

// MARK: - Color+UUID

private extension Color {
    init(from uuid: UUID) {
        let hash = uuid.uuidString.hashValue
        let r = Double((hash & 0xFF0000) >> 16) / 255.0
        let g = Double((hash & 0x00FF00) >> 8) / 255.0
        let b = Double(hash & 0x0000FF) / 255.0
        self.init(red: abs(r), green: abs(g), blue: abs(b))
    }
}
