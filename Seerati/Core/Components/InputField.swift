//
//  InputField.swift
//  Seerati
//
//  Path: Seerati/Core/Components/InputField.swift
//
//  ─────────────────────────────────────────────
//  AR: حقل إدخال نصي موحد مع أيقونة وتسمية
//  EN: Unified text input field with icon and label
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Input Field
struct InputField: View {
    
    // MARK: - Properties
    let label: String
    let placeholder: String
    let icon: String?
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType?
    var isSecure: Bool = false
    var isMultiline: Bool = false
    
    @FocusState private var isFocused: Bool
    
    // MARK: - Init
    init(
        label: String,
        placeholder: String,
        icon: String? = nil,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil,
        isSecure: Bool = false,
        isMultiline: Bool = false
    ) {
        self.label = label
        self.placeholder = placeholder
        self.icon = icon
        self._text = text
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.isSecure = isSecure
        self.isMultiline = isMultiline
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            // Label
            Text(label.uppercased())
                .font(AppFonts.inputLabel())
                .foregroundStyle(AppColors.textSecondary)
            
            // Input Container
            HStack(spacing: AppSpacing.sm) {
                // Icon
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundStyle(
                            isFocused ? AppColors.primary : AppColors.textSecondary
                        )
                        .frame(width: 24)
                }
                
                // Text Field
                if isMultiline {
                    TextField(placeholder, text: $text, axis: .vertical)
                        .lineLimit(3...6)
                        .font(AppFonts.inputText())
                        .foregroundStyle(AppColors.textPrimary)
                        .focused($isFocused)
                } else if isSecure {
                    SecureField(placeholder, text: $text)
                        .font(AppFonts.inputText())
                        .foregroundStyle(AppColors.textPrimary)
                        .focused($isFocused)
                } else {
                    TextField(placeholder, text: $text)
                        .font(AppFonts.inputText())
                        .foregroundStyle(AppColors.textPrimary)
                        .keyboardType(keyboardType)
                        .textContentType(textContentType)
                        .focused($isFocused)
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, isMultiline ? AppSpacing.md : 0)
            .frame(minHeight: isMultiline ? AppSpacing.textAreaHeight : AppSpacing.inputHeight)
            .background(AppColors.inputBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
            .overlay(
                RoundedRectangle(cornerRadius: AppSpacing.radiusMedium)
                    .stroke(
                        isFocused ? AppColors.primary : Color.clear,
                        lineWidth: 1.5
                    )
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
    }
}

// MARK: - Input Field Variants

/// حقل إدخال الاسم
struct NameInputField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        InputField(
            label: label,
            placeholder: placeholder,
            icon: "person.fill",
            text: $text,
            textContentType: .name
        )
    }
}

/// حقل إدخال البريد الإلكتروني
struct EmailInputField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        InputField(
            label: label,
            placeholder: placeholder,
            icon: "envelope.fill",
            text: $text,
            keyboardType: .emailAddress,
            textContentType: .emailAddress
        )
    }
}

/// حقل إدخال رقم الهاتف
struct PhoneInputField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        InputField(
            label: label,
            placeholder: placeholder,
            icon: "phone.fill",
            text: $text,
            keyboardType: .phonePad,
            textContentType: .telephoneNumber
        )
    }
}

/// حقل إدخال الموقع
struct LocationInputField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        InputField(
            label: label,
            placeholder: placeholder,
            icon: "location.fill",
            text: $text,
            textContentType: .fullStreetAddress
        )
    }
}

/// حقل إدخال الرابط
struct URLInputField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        InputField(
            label: label,
            placeholder: placeholder,
            icon: "link",
            text: $text,
            keyboardType: .URL,
            textContentType: .URL
        )
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: 16) {
            InputField(
                label: "Full Name",
                placeholder: "e.g. Alex Morgan",
                icon: "person.fill",
                text: .constant("")
            )
            
            EmailInputField(
                label: "Email Address",
                placeholder: "alex@example.com",
                text: .constant("")
            )
            
            PhoneInputField(
                label: "Phone Number",
                placeholder: "+1 (555) 000-0000",
                text: .constant("")
            )
            
            InputField(
                label: "Summary",
                placeholder: "Write a brief summary...",
                icon: nil,
                text: .constant(""),
                isMultiline: true
            )
        }
        .padding()
    }
    .background(AppColors.background)
}
