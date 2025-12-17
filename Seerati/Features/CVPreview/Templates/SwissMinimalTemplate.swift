//
//  SwissMinimalTemplate.swift
//  Seerati
//
//  Path: Seerati/Features/CVPreview/Templates/SwissMinimalTemplate.swift
//
//  ─────────────────────────────────────────────
//  AR: قالب Swiss Minimal - القالب المجاني
//  EN: Swiss Minimal Template - Free template
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Swiss Minimal Template
struct SwissMinimalTemplate: View {
    
    // MARK: - Properties
    let cv: CVData
    var showWatermark: Bool = false
    
    // MARK: - Colors
    private let primaryColor = Color(hex: "1A1A1A")
    private let secondaryColor = Color(hex: "666666")
    private let accentColor = Color(hex: "2563EB")
    private let backgroundColor = Color.white
    private let dividerColor = Color(hex: "E5E5E5")
    
    // MARK: - Body
    var body: some View {
        ZStack {
            backgroundColor
            
            VStack(alignment: .leading, spacing: 0) {
                // Header
                headerSection
                
                Divider()
                    .background(dividerColor)
                    .padding(.vertical, 16)
                
                // Content
                HStack(alignment: .top, spacing: 24) {
                    // Left Column (Main)
                    VStack(alignment: .leading, spacing: 20) {
                        // Summary
                        if !cv.summary.isEmpty {
                            summarySection
                        }
                        
                        // Experience
                        if !cv.experiences.isEmpty {
                            experienceSection
                        }
                        
                        // Education
                        if !cv.educations.isEmpty {
                            educationSection
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Right Column (Sidebar)
                    VStack(alignment: .leading, spacing: 20) {
                        // Contact
                        contactSection
                        
                        // Skills
                        if !cv.skills.isEmpty {
                            skillsSection
                        }
                    }
                    .frame(width: 160)
                }
                
                Spacer()
                
                // Watermark
                if showWatermark {
                    watermarkView
                }
            }
            .padding(32)
        }
        .frame(width: 595, height: 842) // A4 Size
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Name
            Text(cv.fullName.isEmpty ? "Your Name" : cv.fullName)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(primaryColor)
            
            // Job Title
            if !cv.jobTitle.isEmpty {
                Text(cv.jobTitle)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(accentColor)
                    .textCase(.uppercase)
                    .tracking(1)
            }
        }
    }
    
    // MARK: - Contact Section
    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionTitle("CONTACT")
            
            VStack(alignment: .leading, spacing: 6) {
                if !cv.email.isEmpty {
                    contactRow(icon: "envelope.fill", text: cv.email)
                }
                
                if !cv.phone.isEmpty {
                    contactRow(icon: "phone.fill", text: cv.phone)
                }
                
                if !cv.location.isEmpty {
                    contactRow(icon: "location.fill", text: cv.location)
                }
                
                if !cv.website.isEmpty {
                    contactRow(icon: "globe", text: cv.website)
                }
                
                if !cv.linkedin.isEmpty {
                    contactRow(icon: "link", text: cv.linkedin)
                }
            }
        }
    }
    
    private func contactRow(icon: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 10))
                .foregroundStyle(accentColor)
                .frame(width: 14)
            
            Text(text)
                .font(.system(size: 9))
                .foregroundStyle(secondaryColor)
                .lineLimit(1)
        }
    }
    
    // MARK: - Summary Section
    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionTitle("PROFILE")
            
            Text(cv.summary)
                .font(.system(size: 10))
                .foregroundStyle(secondaryColor)
                .lineSpacing(3)
        }
    }
    
    // MARK: - Experience Section
    private var experienceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("EXPERIENCE")
            
            ForEach(cv.experiences.sorted { $0.sortOrder < $1.sortOrder }, id: \.id) { exp in
                experienceItem(exp)
            }
        }
    }
    
    private func experienceItem(_ exp: Experience) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            // Title & Company
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(exp.jobTitle)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(primaryColor)
                    
                    Text(exp.company)
                        .font(.system(size: 10))
                        .foregroundStyle(accentColor)
                }
                
                Spacer()
                
                // Date
                Text(exp.dateRangeText)
                    .font(.system(size: 9))
                    .foregroundStyle(secondaryColor)
            }
            
            // Description
            if !exp.jobDescription.isEmpty {
                Text(exp.jobDescription)
                    .font(.system(size: 9))
                    .foregroundStyle(secondaryColor)
                    .lineSpacing(2)
                    .padding(.top, 2)
            }
        }
        .padding(.bottom, 8)
    }
    
    
    // MARK: - Education Section
    private var educationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("EDUCATION")
            
            ForEach(cv.educations.sorted { $0.sortOrder < $1.sortOrder }, id: \.id) { edu in
                educationItem(edu)
            }
        }
    }
    
    private func educationItem(_ edu: Education) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(edu.degree)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(primaryColor)
                    
                    Text(edu.institution)
                        .font(.system(size: 10))
                        .foregroundStyle(accentColor)
                    
                    if !edu.fieldOfStudy.isEmpty {
                        Text(edu.fieldOfStudy)
                            .font(.system(size: 9))
                            .foregroundStyle(secondaryColor)
                    }
                }
                
                Spacer()
                
                Text(edu.dateRangeText)
                    .font(.system(size: 9))
                    .foregroundStyle(secondaryColor)
            }
        }
        .padding(.bottom, 6)
    }
    
    // MARK: - Skills Section
    private var skillsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionTitle("SKILLS")
            
            FlowLayout(spacing: 4) {
                ForEach(cv.skills.sorted { $0.sortOrder < $1.sortOrder }, id: \.id) { skill in
                    skillChip(skill.name)
                }
            }
        }
    }
    
    private func skillChip(_ name: String) -> some View {
        Text(name)
            .font(.system(size: 8, weight: .medium))
            .foregroundStyle(primaryColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(hex: "F5F5F5"))
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
    
    // MARK: - Section Title
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 10, weight: .bold))
            .foregroundStyle(primaryColor)
            .tracking(1.5)
    }
    
    // MARK: - Watermark
    private var watermarkView: some View {
        HStack {
            Spacer()
            Text("Made with Seerati")
                .font(.system(size: 8))
                .foregroundStyle(Color(hex: "CCCCCC"))
        }
    }
}

// MARK: - Template Protocol
protocol CVTemplateProtocol: View {
    var cv: CVData { get }
    var showWatermark: Bool { get }
}

// MARK: - Preview
#Preview {
    ScrollView {
        SwissMinimalTemplate(
            cv: CVData(
                cvName: "Preview CV",
                fullName: "Ahmed Al-Rashid",
                jobTitle: "Senior iOS Developer",
                email: "ahmed@example.com",
                phone: "+966 50 000 0000",
                location: "Riyadh, Saudi Arabia",
                summary: "Passionate iOS developer with 5+ years of experience."
            ),
            showWatermark: true
        )
        .border(Color.gray.opacity(0.3))
    }
    .background(Color.gray.opacity(0.2))
}
