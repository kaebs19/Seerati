//
//  SwissMinimalTemplate.swift
//  Seerati
//
//  Path: Seerati/Features/CVPreview/Templates/SwissMinimalTemplate.swift
//
//  ─────────────────────────────────────────────────
//  AR: قالب Swiss Minimal - القالب المجاني المحسّن
//  EN: Swiss Minimal Template - Enhanced Free Template
//  ─────────────────────────────────────────────────

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
    private let chipBgColor = Color(hex: "F5F5F5")
    
    // MARK: - Body
    var body: some View {
        ZStack {
            backgroundColor
            
            VStack(alignment: .leading, spacing: 0) {
                // Header
                headerSection
                    .padding(.bottom, 12)
                
                // Divider
                Rectangle()
                    .fill(dividerColor)
                    .frame(height: 1)
                    .padding(.bottom, 16)
                
                // Content - Two Columns
                HStack(alignment: .top, spacing: 20) {
                    // Main Column (Left - 65%)
                    mainColumn
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Side Column (Right - 35%)
                    sideColumn
                        .frame(width: 150)
                }
                
                Spacer(minLength: 0)
                
                // Watermark
                if showWatermark {
                    watermarkView
                }
            }
            .padding(28)
        }
        .frame(width: 595, height: 842) // A4 Size
        .clipped()
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Name
            Text(cv.fullName.isEmpty ? "Your Name" : cv.fullName)
                .font(.system(size: 26, weight: .bold, design: .default))
                .foregroundStyle(primaryColor)
                .lineLimit(1)
            
            // Job Title
            if !cv.jobTitle.isEmpty {
                Text(cv.jobTitle.uppercased())
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(accentColor)
                    .tracking(1.5)
            }
        }
    }
    
    // MARK: - Main Column
    private var mainColumn: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Summary/Profile
            if !cv.summary.isEmpty {
                sectionView(title: "PROFILE") {
                    Text(cv.summary)
                        .font(.system(size: 9))
                        .foregroundStyle(secondaryColor)
                        .lineSpacing(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            // Experience
            if !cv.experiences.isEmpty {
                sectionView(title: "EXPERIENCE") {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(cv.experiences.sorted { $0.sortOrder < $1.sortOrder }, id: \.id) { exp in
                            experienceItem(exp)
                        }
                    }
                }
            }
            
            // Education
            if !cv.educations.isEmpty {
                sectionView(title: "EDUCATION") {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(cv.educations.sorted { $0.sortOrder < $1.sortOrder }, id: \.id) { edu in
                            educationItem(edu)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Side Column
    private var sideColumn: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Personal Info (if any visible)
            if hasVisiblePersonalInfo {
                sectionView(title: "PERSONAL") {
                    VStack(alignment: .leading, spacing: 5) {
                        if cv.showDateOfBirth, cv.dateOfBirth != nil {
                            infoRow(icon: "calendar", text: cv.formattedDateOfBirth)
                        }
                        if cv.showNationality, !cv.nationality.isEmpty {
                            infoRow(icon: "globe", text: cv.nationality)
                        }
                        if cv.showGender, cv.gender != .preferNotToSay {
                            infoRow(icon: "person.fill", text: cv.gender.localizedName)
                        }
                        if cv.showMaritalStatus, cv.maritalStatus != .preferNotToSay {
                            infoRow(icon: "heart.fill", text: cv.maritalStatus.localizedName)
                        }
                        if cv.showDrivingLicense, cv.drivingLicense != .none {
                            infoRow(icon: "car.fill", text: cv.drivingLicense.localizedName)
                        }
                        if cv.showVisaStatus {
                            infoRow(icon: "doc.text.fill", text: cv.visaStatus.localizedName)
                        }
                    }
                }
            }
            
            // Contact
            sectionView(title: "CONTACT") {
                VStack(alignment: .leading, spacing: 5) {
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
            
            // Skills
            if !cv.skills.isEmpty {
                sectionView(title: "SKILLS") {
                    skillsGrid
                }
            }
        }
    }
    
    // MARK: - Section View
    private func sectionView<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 9, weight: .bold))
                .foregroundStyle(primaryColor)
                .tracking(1.2)
            
            content()
        }
    }
    
    // MARK: - Experience Item
    private func experienceItem(_ exp: Experience) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            // Title & Date
            HStack(alignment: .top) {
                Text(exp.jobTitle)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(primaryColor)
                
                Spacer()
                
                Text(exp.dateRangeText)
                    .font(.system(size: 8))
                    .foregroundStyle(secondaryColor)
            }
            
            // Company
            Text(exp.company)
                .font(.system(size: 9))
                .foregroundStyle(accentColor)
            
            // Description
            if !exp.jobDescription.isEmpty {
                Text(exp.jobDescription)
                    .font(.system(size: 8))
                    .foregroundStyle(secondaryColor)
                    .lineSpacing(1.5)
                    .padding(.top, 2)
                    .lineLimit(4)
            }
        }
    }
    
    // MARK: - Education Item
    private func educationItem(_ edu: Education) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            // Degree & Date
            HStack(alignment: .top) {
                Text(edu.degree)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(primaryColor)
                    .lineLimit(1)
                
                Spacer()
                
                Text(edu.dateRangeText)
                    .font(.system(size: 8))
                    .foregroundStyle(secondaryColor)
            }
            
            // Institution
            Text(edu.institution)
                .font(.system(size: 9))
                .foregroundStyle(accentColor)
            
            // Field of Study
            if !edu.fieldOfStudy.isEmpty {
                Text(edu.fieldOfStudy)
                    .font(.system(size: 8))
                    .foregroundStyle(secondaryColor)
            }
            
            // GPA
            if !edu.gpa.isEmpty {
                HStack(spacing: 3) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 7))
                    Text("GPA: \(edu.gpa)")
                        .font(.system(size: 8, weight: .medium))
                }
                .foregroundStyle(Color.orange)
                .padding(.top, 1)
            }
        }
    }
    
    // MARK: - Contact Row
    private func contactRow(icon: String, text: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 8))
                .foregroundStyle(accentColor)
                .frame(width: 12)
            
            Text(text)
                .font(.system(size: 8))
                .foregroundStyle(secondaryColor)
                .lineLimit(1)
        }
    }
    
    // MARK: - Info Row (for personal info)
    private func infoRow(icon: String, text: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 8))
                .foregroundStyle(accentColor)
                .frame(width: 12)
            
            Text(text)
                .font(.system(size: 8))
                .foregroundStyle(secondaryColor)
                .lineLimit(1)
        }
    }
    
    // MARK: - Has Visible Personal Info
    private var hasVisiblePersonalInfo: Bool {
        (cv.showDateOfBirth && cv.dateOfBirth != nil) ||
        (cv.showNationality && !cv.nationality.isEmpty) ||
        (cv.showGender && cv.gender != .preferNotToSay) ||
        (cv.showMaritalStatus && cv.maritalStatus != .preferNotToSay) ||
        (cv.showDrivingLicense && cv.drivingLicense != .none) ||
        cv.showVisaStatus
    }
    
    // MARK: - Skills Grid
    private var skillsGrid: some View {
        FlowLayout(spacing: 4) {
            ForEach(cv.skills.sorted { $0.sortOrder < $1.sortOrder }, id: \.id) { skill in
                skillChip(skill.name)
            }
        }
    }
    
    private func skillChip(_ name: String) -> some View {
        Text(name)
            .font(.system(size: 7, weight: .medium))
            .foregroundStyle(primaryColor)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(chipBgColor)
            .clipShape(RoundedRectangle(cornerRadius: 3))
    }
    
    // MARK: - Watermark
    private var watermarkView: some View {
        HStack {
            Spacer()
            Text("Made with Seerati")
                .font(.system(size: 7))
                .foregroundStyle(Color(hex: "CCCCCC"))
        }
    }
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
