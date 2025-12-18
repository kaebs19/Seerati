//
//  CVPreviewView.swift
//  Seerati
//
//  Path: Seerati/Features/CVPreview/Views/CVPreviewView.swift
//
//  ─────────────────────────────────────────────────
//  AR: شاشة معاينة السيرة الذاتية المحسّنة
//  EN: Enhanced CV Preview screen
//  ─────────────────────────────────────────────────

import SwiftUI

// MARK: - CV Preview View
struct CVPreviewView: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @State var viewModel: CVPreviewViewModel
    
    // MARK: - Init
    init(cv: CVData, template: Template? = nil) {
        self._viewModel = State(initialValue: CVPreviewViewModel(cv: cv, template: template))
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color(hex: "E8E8E8")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Preview Area
                    previewArea
                    
                    // Bottom Bar
                    bottomBar
                }
            }
            .navigationTitle(CVPreviewStrings.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(AppColors.textPrimary)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    zoomControls
                }
            }
        }
        .sheet(isPresented: $viewModel.showTemplateSelector) {
            TemplateSelectorSheet(
                selectedTemplate: viewModel.selectedTemplate,
                onSelect: { template in
                    viewModel.selectTemplate(template)
                }
            )
        }
        .sheet(isPresented: $viewModel.showShareSheet) {
            if let pdfData = viewModel.generatedPDFData {
                ShareSheet(activityItems: viewModel.getShareItems())
            }
        }
        .sheet(isPresented: $viewModel.showPremiumPage) {
            PremiumUpgradeSheet()
        }
        .alert(CVPreviewStrings.exportLimitReached, isPresented: $viewModel.showExportLimitAlert) {
            Button(CVPreviewStrings.upgrade) {
                viewModel.showPremiumPage = true
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(CVPreviewStrings.exportLimitMessage)
        }
        .alert(CVPreviewStrings.exportFailed, isPresented: $viewModel.showExportError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
        .overlay {
            if viewModel.isExporting {
                exportingOverlay
            }
        }
    }
    
    // MARK: - Preview Area
    private var previewArea: some View {
        GeometryReader { geometry in
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                VStack {
                    // CV Template with shadow
                    SwissMinimalTemplate(
                        cv: viewModel.cv,
                        showWatermark: viewModel.shouldAddWatermark
                    )
                    .scaleEffect(viewModel.scale)
                    .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 8)
                    .frame(
                        width: 595 * viewModel.scale,
                        height: 842 * viewModel.scale
                    )
                }
                .frame(
                    minWidth: geometry.size.width,
                    minHeight: geometry.size.height
                )
            }
        }
    }
    
    // MARK: - Bottom Bar
    private var bottomBar: some View {
        VStack(spacing: 0) {
            // Watermark Notice
            if viewModel.shouldAddWatermark {
                watermarkNotice
            }
            
            // Actions
            HStack(spacing: 12) {
                // Change Template
                Button {
                    viewModel.showTemplateSelector = true
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "square.on.square")
                            .font(.system(size: 14))
                        Text(CVPreviewStrings.changeTemplate)
                            .font(AppFonts.caption(weight: .medium))
                    }
                    .foregroundStyle(AppColors.textPrimary)
                    .frame(height: 48)
                    .padding(.horizontal, 14)
                    .background(AppColors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                // Export PDF
                Button {
                    Task {
                        await viewModel.exportPDF()
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.down.doc.fill")
                            .font(.system(size: 16, weight: .medium))
                        
                        Text(CVPreviewStrings.exportPDF)
                            .font(AppFonts.button())
                        
                        if !viewModel.isPremium {
                            Text("(\(viewModel.remainingExports))")
                                .font(AppFonts.caption())
                                .foregroundStyle(.white.opacity(0.7))
                        }
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(AppColors.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(.horizontal, AppSpacing.screenHorizontal)
            .padding(.vertical, AppSpacing.md)
            .background(AppColors.background)
        }
    }
    
    // MARK: - Watermark Notice
    private var watermarkNotice: some View {
        HStack(spacing: 8) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 14))
            
            Text(CVPreviewStrings.watermarkNotice)
                .font(AppFonts.caption())
            
            Spacer()
            
            Button {
                viewModel.showPremiumPage = true
            } label: {
                Text(CVPreviewStrings.upgrade)
                    .font(AppFonts.caption(weight: .semibold))
                    .foregroundStyle(AppColors.primary)
            }
        }
        .foregroundStyle(AppColors.warning)
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
        .background(AppColors.warning.opacity(0.1))
    }
    
    // MARK: - Zoom Controls
    private var zoomControls: some View {
        HStack(spacing: 6) {
            Button {
                viewModel.zoomOut()
            } label: {
                Image(systemName: "minus.magnifyingglass")
                    .font(.system(size: 14))
                    .foregroundStyle(AppColors.textPrimary)
            }
            
            Text("\(Int(viewModel.scale * 100))%")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(AppColors.textSecondary)
                .frame(width: 38)
            
            Button {
                viewModel.zoomIn()
            } label: {
                Image(systemName: "plus.magnifyingglass")
                    .font(.system(size: 14))
                    .foregroundStyle(AppColors.textPrimary)
            }
        }
    }
    
    // MARK: - Exporting Overlay
    private var exportingOverlay: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)
                
                Text(CVPreviewStrings.exporting)
                    .font(AppFonts.body(weight: .medium))
                    .foregroundStyle(.white)
            }
            .padding(32)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

// MARK: - Template Selector Sheet
struct TemplateSelectorSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    let selectedTemplate: Template
    var onSelect: (Template) -> Void
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(Template.allTemplates, id: \.id) { template in
                        TemplateSelectionCard(
                            template: template,
                            isSelected: template.id == selectedTemplate.id
                        ) {
                            onSelect(template)
                            dismiss()
                        }
                    }
                }
                .padding(AppSpacing.screenHorizontal)
            }
            .background(AppColors.background)
            .navigationTitle(CVPreviewStrings.selectTemplate)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(CVPreviewStrings.done) {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

// MARK: - Template Selection Card
struct TemplateSelectionCard: View {
    
    let template: Template
    var isSelected: Bool
    var onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                // Preview
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(template.primaryColor)
                        .aspectRatio(0.7, contentMode: .fit)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isSelected ? AppColors.primary : Color.clear, lineWidth: 3)
                        )
                        .overlay(
                            // Mini template preview
                            VStack(alignment: .leading, spacing: 4) {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.white.opacity(0.3))
                                    .frame(width: 60, height: 8)
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: 40, height: 4)
                                Spacer()
                            }
                            .padding(12)
                        )
                    
                    // Premium Badge
                    if template.isPremium && !template.isAvailable {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(.white)
                            .padding(6)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                            .padding(8)
                    }
                    
                    // Selected Badge
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(AppColors.primary)
                            .background(Circle().fill(.white))
                            .padding(8)
                    }
                }
                
                // Name
                Text(template.localizedName)
                    .font(AppFonts.caption(weight: .medium))
                    .foregroundStyle(AppColors.textPrimary)
                
                // Badge
                Text(template.isPremium ? CVPreviewStrings.premium : CVPreviewStrings.free)
                    .font(AppFonts.caption2())
                    .foregroundStyle(template.isPremium ? AppColors.warning : AppColors.success)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Premium Upgrade Sheet
struct PremiumUpgradeSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Icon
                Image(systemName: "crown.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(Color.orange)
                    .padding(.top, 40)
                
                // Title
                Text("Upgrade to Premium")
                    .font(.system(size: 24, weight: .bold))
                
                // Features
                VStack(alignment: .leading, spacing: 12) {
                    featureRow(icon: "infinity", text: "Unlimited PDF Exports")
                    featureRow(icon: "doc.text", text: "No Watermark")
                    featureRow(icon: "rectangle.stack", text: "All Premium Templates")
                    featureRow(icon: "star.fill", text: "Priority Support")
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                // Buttons
                VStack(spacing: 12) {
                    Button {
                        // TODO: Purchase
                        dismiss()
                    } label: {
                        Text("Upgrade Now")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Maybe Later")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
    
    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(Color.orange)
                .frame(width: 24)
            Text(text)
                .font(.system(size: 15))
            Spacer()
        }
    }
}

// MARK: - Preview
#Preview {
    CVPreviewView(cv: CVData.preview)
}
