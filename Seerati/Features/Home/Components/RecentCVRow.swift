//
//  RecentCVRow.swift
//  Seerati
//
//  Path: Seerati/Features/Home/Components/RecentCVRow.swift
//
//  ─────────────────────────────────────────────
//  AR: صف عرض السيرة الذاتية في قائمة الأخيرة
//  EN: CV row item for recent CVs list
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Recent CV Row
struct RecentCVRow: View {
    
    // MARK: - Properties
    let cv: CVData
    var onTap: () -> Void
    var onMenuTap: () -> Void
    
    // MARK: - Private
    @State private var iconColor: Color = AppColors.primary
    
    // MARK: - Body
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppSpacing.md) {
                // Icon
                CVRowIcon(color: iconColor)
                
                // Info
                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    Text(displayName)
                        .font(AppFonts.body(weight: .semibold))
                        .foregroundStyle(AppColors.textPrimary)
                        .lineLimit(1)
                    
                    Text(timeAgo)
                        .font(AppFonts.caption())
                        .foregroundStyle(AppColors.textSecondary)
                }
                
                Spacer()
                
                // Menu
                Button(action: onMenuTap) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(AppColors.textSecondary)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
            }
            .padding(AppSpacing.md)
            .background(AppColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
        }
        .buttonStyle(.plain)
        .onAppear {
            assignRandomColor()
        }
    }
    
    // MARK: - Computed
    private var displayName: String {
        cv.cvName.isEmpty ? "Untitled CV" : cv.cvName
    }
    
    private var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        let relative = formatter.localizedString(for: cv.updatedAt, relativeTo: Date())
        return "Edited \(relative)"
    }
    
    // MARK: - Methods
    private func assignRandomColor() {
        let colors: [Color] = [
            AppColors.primary,
            Color(hex: "3B82F6"),
            Color(hex: "8B5CF6"),
            Color(hex: "EC4899"),
            Color(hex: "F59E0B")
        ]
        iconColor = colors.randomElement() ?? AppColors.primary
    }
}

// MARK: - CV Row Icon
struct CVRowIcon: View {
    
    var color: Color = AppColors.primary
    var size: CGFloat = 48
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.25)
                .fill(color.opacity(0.15))
                .frame(width: size, height: size)
            
            Image(systemName: "doc.text.fill")
                .font(.system(size: size * 0.4))
                .foregroundStyle(color)
        }
    }
}

// MARK: - Recent CVs List
struct RecentCVsList: View {
    
    let cvs: [CVData]
    var onSelect: (CVData) -> Void
    var onMenu: (CVData) -> Void
    
    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            ForEach(cvs) { cv in
                RecentCVRow(
                    cv: cv,
                    onTap: { onSelect(cv) },
                    onMenuTap: { onMenu(cv) }
                )
            }
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 12) {
        RecentCVRow(
            cv: CVData.preview,
            onTap: { print("Tapped") },
            onMenuTap: { print("Menu") }
        )
        
        RecentCVRow(
            cv: {
                let cv = CVData(cvName: "Frontend Dev Resume")
                cv.updatedAt = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
                return cv
            }(),
            onTap: {},
            onMenuTap: {}
        )
    }
    .padding()
    .background(AppColors.background)
}
