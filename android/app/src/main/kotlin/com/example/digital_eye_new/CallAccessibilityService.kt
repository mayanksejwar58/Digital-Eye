package com.example.digital_eye_new

import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent

class CallAccessibilityService : AccessibilityService() {

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        // Accessibility service active
        // NO call control here
    }

    override fun onInterrupt() {
        // Required override
    }
}
