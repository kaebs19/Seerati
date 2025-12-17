//
//  StepIndicator.swift
//  Seerati
//
//  Path: Seerati/Core/Components/StepIndicator.swift
//
//  ─────────────────────────────────────────────
//  AR: مؤشر تقدم الخطوات في عملية الإنشاء
//  EN: Step progress indicator for creation flow
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Step Indicator
struct StepIndicator: View {
    
    // MARK: - Properties
    let totalSteps: Int
    let currentStep: Int
    var activeColor: Color = AppColors.primary
    var inactiveColor: Color = AppColors.surface
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: AppSpacing.xs) {
            ForEach(0..<totalSteps, id: \.self) { index in
                Capsule()
                    .fill(index < currentStep ? activeColor : inactiveColor)
                    .frame(height: 4)
                    .animation(.easeInOut(duration: 0.3), value: currentStep)
            }
        }
    }
}

// MARK: - Step Header
struct StepHeader: View {
    
    let step: Int
    let totalSteps: Int
    let title: String
    let subtitle: String?
    
    init(
        step: Int,
        of totalSteps: Int,
        title: String,
        subtitle: String? = nil
    ) {
        self.step = step
        self.totalSteps = totalSteps
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            // Progress
            HStack {
                Text("STEP \(step) OF \(totalSteps)")
                    .font(AppFonts.caption(weight: .semibold))
                    .foregroundStyle(AppColors.primary)
                
                Spacer()
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(AppFonts.caption())
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            
            // Indicator
            StepIndicator(totalSteps: totalSteps, currentStep: step)
            
            // Title
            Text(title)
                .font(AppFonts.title())
                .foregroundStyle(AppColors.textPrimary)
        }
    }
}

// MARK: - Circular Step Indicator
struct CircularStepIndicator: View {
    
    let step: Int
    let totalSteps: Int
    var size: CGFloat = 60
    
    private var progress: CGFloat {
        CGFloat(step) / CGFloat(totalSteps)
    }
    
    var body: some View {
        ZStack {
            // Background Circle
            Circle()
                .stroke(AppColors.surface, lineWidth: 4)
            
            // Progress Circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(AppColors.primary, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.3), value: step)
            
            // Step Text
            Text("\(step)/\(totalSteps)")
                .font(AppFonts.caption(weight: .semibold))
                .foregroundStyle(AppColors.textPrimary)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 32) {
        StepIndicator(totalSteps: 4, currentStep: 2)
        
        StepHeader(
            step: 1,
            of: 4,
            title: "Let's start with the basics.",
            subtitle: "Basic Info"
        )
        
        CircularStepIndicator(step: 2, totalSteps: 4)
    }
    .padding()
    .background(AppColors.background)
}
