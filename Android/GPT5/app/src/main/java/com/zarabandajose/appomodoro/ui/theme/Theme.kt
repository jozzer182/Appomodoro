package com.zarabandajose.appomodoro.ui.theme

import androidx.compose.material3.ColorScheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

@Composable
fun AppTheme(
    accentColor: Color,
    content: @Composable () -> Unit
) {
    val scheme: ColorScheme = darkColorScheme(
        primary = accentColor,
        onPrimary = Color.White,
        secondary = accentColor.copy(alpha = 0.85f),
        onSecondary = Color.White,
        tertiary = accentColor.copy(alpha = 0.75f),
        onTertiary = Color.White,
        background = Graphite900,
        onBackground = TextPrimary,
        surface = Graphite800,
        onSurface = TextPrimary,
        surfaceVariant = Graphite700,
        onSurfaceVariant = TextSecondary,
        outline = TickSoft,
        outlineVariant = TickBright,
        scrim = Color(0xFF000000)
    )

    MaterialTheme(
        colorScheme = scheme,
        typography = Typography,
        content = content
    )
}