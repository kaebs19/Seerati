//
//  SkillCard.swift
//  Seerati
//
//  Path: Seerati/Features/Skills/Components/SkillCard.swift
//
//  ─────────────────────────────────────────────
//  AR: بطاقة عرض المهارة في القائمة
//  EN: Skill card for list display
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Skill Card
struct SkillCard: View {
    
    // MARK: - Properties
    let skill: Skill
    var onEdit: () -> Void
    var onDelete: () -> Void
    
    @State private var showOptions = false
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            // Skill Info
            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text(skill.name)
                    .font(AppFonts.body(weight: .medium))
                    .foregroundStyle(AppColors.textPrimary)
                
                Text(localizedLevel)
                    .font(AppFonts.caption())
                    .foregroundStyle(AppColors.textSecondary)
            }
            
            Spacer()
            
            // Progress Bar
            SkillProgressBar(percentage: skill.levelPercentage)
                .frame(width: 80)
            
            // Menu
            Button {
                showOptions = true
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 14))
                    .foregroundStyle(AppColors.textSecondary)
                    .frame(width: 28, height: 28)
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
        .confirmationDialog("Options", isPresented: $showOptions) {
            Button(SkillsStrings.editSkill) {
                onEdit()
            }
            Button(SkillsStrings.deleteSkill, role: .destructive) {
                onDelete()
            }
            Button("Cancel", role: .cancel) {}
        }
    }
    
    // MARK: - Helpers
    private var localizedLevel: String {
        LocalizationManager.shared.isArabic ? skill.levelTextArabic : skill.levelText
    }
}

// MARK: - Skill Progress Bar
struct SkillProgressBar: View {
    let percentage: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: 4)
                    .fill(AppColors.border)
                    .frame(height: 8)
                
                // Progress
                RoundedRectangle(cornerRadius: 4)
                    .fill(progressColor)
                    .frame(width: geometry.size.width * percentage, height: 8)
            }
        }
        .frame(height: 8)
    }
    
    private var progressColor: Color {
        switch percentage {
        case 0..<0.4: return Color(hex: "F59E0B") // Amber
        case 0.4..<0.7: return Color(hex: "3B82F6") // Blue
        default: return Color(hex: "10B981") // Green
        }
    }
}

// MARK: - Skills Section View
struct SkillsSectionView: View {
    
    let title: String
    let icon: String
    let skills: [Skill]
    var onEdit: (Skill) -> Void
    var onDelete: (Skill) -> Void
    
    var body: some View {
        if !skills.isEmpty {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                // Section Header
                HStack(spacing: AppSpacing.sm) {
                    Image(systemName: icon)
                        .font(.system(size: 14))
                        .foregroundStyle(AppColors.primary)
                    
                    Text(title)
                        .font(AppFonts.caption(weight: .semibold))
                        .foregroundStyle(AppColors.textSecondary)
                }
                
                // Skills
                VStack(spacing: AppSpacing.xs) {
                    ForEach(skills, id: \.id) { skill in
                        SkillCard(
                            skill: skill,
                            onEdit: { onEdit(skill) },
                            onDelete: { onDelete(skill) }
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Skill Suggestion Chip
struct SkillSuggestionChip: View {
    
    let name: String
    var isSelected: Bool = false
    var onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 4) {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                }
                Text(name)
                    .font(AppFonts.caption())
            }
            .foregroundStyle(isSelected ? .white : AppColors.textPrimary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? AppColors.primary : AppColors.surface)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(isSelected ? Color.clear : AppColors.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 12) {
        SkillCard(
            skill: Skill.preview,
            onEdit: {},
            onDelete: {}
        )
        
        SkillCard(
            skill: Skill(name: "Communication", level: 5, category: "Soft Skills"),
            onEdit: {},
            onDelete: {}
        )
        
        SkillCard(
            skill: Skill(name: "Python", level: 2, category: "Technical"),
            onEdit: {},
            onDelete: {}
        )
        
        // Suggestion Chips
        HStack {
            SkillSuggestionChip(name: "Swift", isSelected: true) {}
            SkillSuggestionChip(name: "Python") {}
            SkillSuggestionChip(name: "React") {}
        }
    }
    .padding()
    .background(AppColors.background)
}
