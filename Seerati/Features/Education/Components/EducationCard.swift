//
//  EducationCard.swift
//  Seerati
//
//  Path: Seerati/Features/Education/Components/EducationCard.swift
//
//  ─────────────────────────────────────────────
//  AR: بطاقة عرض التعليم في القائمة
//  EN: Education card for list display
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Education Card
struct EducationCard: View {
    
    // MARK: - Properties
    let education: Education
    var onEdit: () -> Void
    var onDelete: () -> Void
    
    @State private var showOptions = false
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            // Header
            HStack(alignment: .top) {
                // Institution Icon
                InstitutionIcon(name: education.institution)
                
                // Info
                VStack(alignment: .leading, spacing: 2) {
                    Text(education.degree)
                        .font(AppFonts.body(weight: .semibold))
                        .foregroundStyle(AppColors.textPrimary)
                    
                    Text(education.institution)
                        .font(AppFonts.subheadline())
                        .foregroundStyle(AppColors.textSecondary)
                    
                    if !education.fieldOfStudy.isEmpty {
                        Text(education.fieldOfStudy)
                            .font(AppFonts.caption())
                            .foregroundStyle(AppColors.textSecondary)
                    }
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
            
            // Date & Location & GPA
            HStack(spacing: AppSpacing.sm) {
                // Date
                Label(education.dateRangeText, systemImage: "calendar")
                    .font(AppFonts.caption())
                    .foregroundStyle(AppColors.textSecondary)
                
                if !education.location.isEmpty {
                    Text("•")
                        .foregroundStyle(AppColors.textSecondary)
                    
                    Label(education.location, systemImage: "location")
                        .font(AppFonts.caption())
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            
            // GPA Badge
            if !education.gpa.isEmpty {
                GPABadge(gpa: education.gpa)
                    .padding(.top, AppSpacing.xxs)
            }
            
            // Currently Studying Badge
            if education.isCurrentlyStudying {
                StudyingBadge()
                    .padding(.top, AppSpacing.xxs)
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
        .confirmationDialog("Options", isPresented: $showOptions) {
            Button(EducationStrings.editEducation) {
                onEdit()
            }
            Button(EducationStrings.deleteEducation, role: .destructive) {
                onDelete()
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

// MARK: - Institution Icon
struct InstitutionIcon: View {
    
    let name: String
    var size: CGFloat = 44
    
    private var initial: String {
        String(name.prefix(1)).uppercased()
    }
    
    private var backgroundColor: Color {
        let colors: [Color] = [
            Color(hex: "6366F1"), // Indigo
            Color(hex: "8B5CF6"), // Purple
            Color(hex: "06B6D4"), // Cyan
            Color(hex: "14B8A6"), // Teal
            Color(hex: "F59E0B")  // Amber
        ]
        let index = abs(name.hashValue) % colors.count
        return colors[index]
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.2)
                .fill(backgroundColor)
                .frame(width: size, height: size)
            
            Image(systemName: "building.columns.fill")
                .font(.system(size: size * 0.4))
                .foregroundStyle(.white)
        }
    }
}

// MARK: - GPA Badge
struct GPABadge: View {
    let gpa: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.system(size: 10))
            Text("GPA: \(gpa)")
        }
        .font(AppFonts.caption2(weight: .semibold))
        .foregroundStyle(Color(hex: "F59E0B"))
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(hex: "F59E0B").opacity(0.15))
        .clipShape(Capsule())
    }
}

// MARK: - Studying Badge
struct StudyingBadge: View {
    var body: some View {
        Text(EducationStrings.currentlyStudying)
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
        EducationCard(
            education: Education.preview,
            onEdit: {},
            onDelete: {}
        )
        
        EducationCard(
            education: {
                let edu = Education(
                    degree: "Master of Business Administration",
                    fieldOfStudy: "Finance", institution: "Harvard Business School",
                    location: "Boston, USA",
                    startDate: Calendar.current.date(byAdding: .year, value: -3, to: Date())!,
                    endDate: Calendar.current.date(byAdding: .year, value: -1, to: Date())!,
                    gpa: "3.9 / 4.0"
                )
                return edu
            }(),
            onEdit: {},
            onDelete: {}
        )
    }
    .padding()
    .background(AppColors.background)
}
