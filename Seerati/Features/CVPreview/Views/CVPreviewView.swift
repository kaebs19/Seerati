//
//  CVPreviewView.swift
//  Seerati
//
//  Path: Seerati/Features/CVPreview/Views/CVPreviewView.swift
//
//  ─────────────────────────────────────────────
//  AR: شاشة معاينة السيرة الذاتية
//  EN: CV Preview screen
//  ─────────────────────────────────────────────

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
                Color(hex: "F0F0F0")
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
                ShareSheet(activityItems: [pdfData])
            }
        }
        .sheet(isPresented: $viewModel.showPremiumPage) {
            PremiumPlansSheet { yearly in
                await viewModel.purchaseManager.purchasePremium(yearly: yearly)
            }
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
        ScrollView([.horizontal, .vertical], showsIndicators: true) {
            VStack {
                // CV Template
                SwissMinimalTemplate(
                    cv: viewModel.cv,
                    showWatermark: viewModel.shouldAddWatermark
                )
                .scaleEffect(viewModel.scale)
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                .padding(20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                SecondaryActionButton(
                    icon: "square.on.square",
                    title: CVPreviewStrings.changeTemplate
                ) {
                    viewModel.showTemplateSelector = true
                }
                
                // Export PDF
                PrimaryActionButton(
                    icon: "arrow.down.doc.fill",
                    title: CVPreviewStrings.exportPDF,
                    remainingExports: viewModel.isPremium ? nil : viewModel.remainingExports
                ) {
                    Task {
                        await viewModel.exportPDF()
                    }
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
            
            Button(CVPreviewStrings.upgrade) {
                viewModel.showPremiumPage = true
            }
            .font(AppFonts.caption(weight: .semibold))
            .foregroundStyle(AppColors.primary)
        }
        .foregroundStyle(AppColors.warning)
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
        .background(AppColors.warning.opacity(0.1))
    }
    
    // MARK: - Zoom Controls
    private var zoomControls: some View {
        HStack(spacing: 8) {
            Button {
                viewModel.zoomOut()
            } label: {
                Image(systemName: "minus.magnifyingglass")
                    .foregroundStyle(AppColors.textPrimary)
            }
            
            Text("\(Int(viewModel.scale * 100))%")
                .font(AppFonts.caption(weight: .medium))
                .foregroundStyle(AppColors.textSecondary)
                .frame(width: 40)
            
            Button {
                viewModel.zoomIn()
            } label: {
                Image(systemName: "plus.magnifyingglass")
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

// MARK: - Primary Action Button
struct PrimaryActionButton: View {
    let icon: String
    let title: String
    var remainingExports: Int? = nil
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                
                Text(title)
                    .font(AppFonts.button())
                
                if let remaining = remainingExports {
                    Text("(\(remaining))")
                        .font(AppFonts.caption())
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(AppColors.primary)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
        }
    }
}

// MARK: - Secondary Action Button
struct SecondaryActionButton: View {
    let icon: String
    let title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                
                Text(title)
                    .font(AppFonts.caption(weight: .medium))
            }
            .foregroundStyle(AppColors.textPrimary)
            .frame(height: 50)
            .padding(.horizontal, 16)
            .background(AppColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
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

// MARK: - Preview
#Preview {
    CVPreviewView(cv: CVData.preview)
}
