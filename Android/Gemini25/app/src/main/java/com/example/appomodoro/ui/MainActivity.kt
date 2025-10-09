package com.example.appomodoro.ui

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.viewModels
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.ui.Modifier
import com.example.appomodoro.domain.PomodoroEngine
import com.example.appomodoro.ui.screens.HomeScreen
import com.example.appomodoro.ui.theme.AppomodoroTheme

class MainActivity : ComponentActivity() {
    private val pomodoroEngine: PomodoroEngine by viewModels {
        PomodoroEngineFactory(this)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            AppomodoroTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    HomeScreen(pomodoroEngine)
                }
            }
        }
    }
}

class PomodoroEngineFactory(private val context: android.content.Context) : androidx.lifecycle.ViewModelProvider.Factory {
    override fun <T : androidx.lifecycle.ViewModel> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(PomodoroEngine::class.java)) {
            @Suppress("UNCHECKED_CAST")
            return PomodoroEngine(context) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }
}
