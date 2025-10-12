package com.zarabandajose.appomodoro.ui.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

private val DarkColorScheme = darkColorScheme(
    primary = BlueViolet,
    onPrimary = Color.White,
    primaryContainer = BlueVioletDark,
    onPrimaryContainer = BlueVioletLight,
    secondary = BlueVioletLight,
    onSecondary = Color.Black,
    secondaryContainer = MediumGraphite,
    onSecondaryContainer = TextPrimary,
    tertiary = WarningOrange,
    onTertiary = Color.Black,
    background = DarkGraphite,
    onBackground = TextPrimary,
    surface = MediumGraphite,
    onSurface = TextPrimary,
    surfaceVariant = LightGraphite,
    onSurfaceVariant = TextSecondary,
    error = ErrorRed,
    onError = Color.White,
    outline = TextTertiary,
    outlineVariant = LightGraphite
)

@Composable
fun AppomodoroTheme(
    darkTheme: Boolean = true,
    dynamicColor: Boolean = false,
    content: @Composable () -> Unit
) {
    // Force dark theme for this app
    val colorScheme = DarkColorScheme

    MaterialTheme(
        colorScheme = colorScheme,
        typography = Typography,
        content = content
    )
}