//
//  ExperienceCard.swift
//  Seerati
//
//  Path: Seerati/Features/Experience/Components/ExperienceCard.swift
//
//  ─────────────────────────────────────────────
//  AR: بطاقة عرض الخبرة العملية في القائمة
//  EN: Experience card for list display
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Experience Card
struct ExperienceCard: View {
    
    // MARK: - Properties
    let experience: Experience
    var onEdit: () -> Void
    var onDelete: () -> Void
    
    @State private var showOptions = false
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            // Header
            HStack(alignment: .top) {
                // Company Icon
                CompanyIcon(name: experience.company)
                
                // Info
                VStack(alignment: .leading, spacing: 2) {
                    Text(experience.jobTitle)
                        .font(AppFonts.body(weight: .semibold))
                        .foregroundStyle(AppColors.textPrimary)
                    
                    Text(experience.company)
                        .font(AppFonts.subheadline())
                        .foregroundStyle(AppColors.textSecondary)
                }
                
                Spacer()
                
                // Menu
                Button {
                    showOptions = true
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 16))
                        .foregroundStyle(AppColors.textSecondary)
                        .frame(width: 32, height: 32)
                }
            }
            
            // Date & Location
            HStack(spacing: AppSpacing.sm) {
                // Date
                Label(experience.dateRangeText, systemImage: "calendar")
                    .font(AppFonts.caption())
                    .foregroundStyle(AppColors.textSecondary)
                
                if !experience.location.isEmpty {
                    // Divider
                    Text("•")
                        .foregroundStyle(AppColors.textSecondary)
                    
                    // Location
                    Label(experience.location, systemImage: "location")
                        .font(AppFonts.caption())
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            
            // Description
            if !experience.jobDescription.isEmpty {
                Text(experience.jobDescription)
                    .font(AppFonts.caption())
                    .foregroundStyle(AppColors.textSecondary)
                    .lineLimit(3)
                    .padding(.top, AppSpacing.xxs)
            }
            
            // Current Badge
            if experience.isCurrentJob {
                CurrentBadge()
                    .padding(.top, AppSpacing.xxs)
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
        .confirmationDialog("Options", isPresented: $showOptions) {
            Button(ExperienceStrings.editExperience) {
                onEdit()
            }
            Button(ExperienceStrings.deleteExperience, role: .destructive) {
                onDelete()
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

// MARK: - Company Icon
struct CompanyIcon: View {
    
    let name: String
    var size: CGFloat = 44
    
    private var initial: String {
        String(name.prefix(1)).uppercased()
    }
    
    private var backgroundColor: Color {
        let colors: [Color] = [
            Color(hex: "3B82F6"),
            Color(hex: "8B5CF6"),
            Color(hex: "EC4899"),
            Color(hex: "F59E0B"),
            Color(hex: "10B981")
        ]
        let index = abs(name.hashValue) % colors.count
        return colors[index]
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.2)
                .fill(backgroundColor)
                .frame(width: size, height: size)
            
            Text(initial)
                .font(.system(size: size * 0.4, weight: .bold))
                .foregroundStyle(.white)
        }
    }
}

// MARK: - Current Badge
struct CurrentBadge: View {
    var body: some View {
        Text("Current")
            .font(AppFonts.caption2(weight: .semibold))
            .foregroundStyle(AppColors.primary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(AppColors.primary.opacity(0.15))
            .clipShape(Capsule())
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 12) {
        ExperienceCard(
            experience: Experience.preview,
            onEdit: {},
            onDelete: {}
        )
        
        ExperienceCard(
            experience: {
                let exp = Experience(
                    jobTitle: "Junior Developer",
                    company: "Startup Inc",
                    location: "Remote",
                    startDate: Calendar.current.date(byAdding: .year, value: -4, to: Date())!,
                    endDate: Calendar.current.date(byAdding: .year, value: -2, to: Date())!,
                    jobDescription: "Developed mobile applications using Swift and React Native."
                )
                return exp
            }(),
            onEdit: {},
            onDelete: {}
        )
    }
    .padding()
    .background(AppColors.background)
}
