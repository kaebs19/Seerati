//
//  SectionHeader.swift
//  Seerati
//
//  Path: Seerati/Core/Components/SectionHeader.swift
//
//  ─────────────────────────────────────────────
//  AR: عنوان قسم مع زر إجراء اختياري
//  EN: Section header with optional action button
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Section Header
struct SectionHeader: View {
    
    // MARK: - Properties
    let title: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    
    // MARK: - Body
    var body: some View {
        HStack {
            Text(title)
                .font(AppFonts.title3())
                .foregroundStyle(AppColors.textPrimary)
            
            Spacer()
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(AppFonts.subheadline(weight: .medium))
                        .foregroundStyle(AppColors.primary)
                }
            }
        }
    }
}

// MARK: - Section Container
struct SectionContainer<Content: View>: View {
    
    let title: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            SectionHeader(
                title: title,
                actionTitle: actionTitle,
                action: action
            )
            
            content()
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 24) {
        SectionHeader(title: "Templates")
        
        SectionHeader(
            title: "Recent CVs",
            actionTitle: "View all"
        ) {
            print("View all tapped")
        }
        
        SectionContainer(
            title: "Skills",
            actionTitle: "Add"
        ) {
            print("Add skill")
        } content: {
            Text("Skills content here")
                .foregroundStyle(AppColors.textSecondary)
        }
    }
    .padding()
    .background(AppColors.background)
}
