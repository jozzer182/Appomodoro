package com.zarabandajose.appomodoro

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.viewModels
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.lifecycle.viewmodel.compose.viewModel
import com.zarabandajose.appomodoro.data.SettingsStore
import com.zarabandajose.appomodoro.ui.screens.HomeScreen
import com.zarabandajose.appomodoro.ui.screens.SettingsScreen
import com.zarabandajose.appomodoro.ui.theme.AppomodoroTheme
import kotlinx.coroutines.android.awaitFrame

class MainActivity : ComponentActivity() {

    private lateinit var settingsStore: SettingsStore
    private lateinit var viewModel: PomodoroViewModel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        settingsStore = SettingsStore(this)
        viewModel = PomodoroViewModel(this, settingsStore)
        enableEdgeToEdge()
        setContent {
            AppomodoroTheme {
                var currentScreen by remember { mutableStateOf("home") }

                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    when (currentScreen) {
                        "home" -> HomeScreen(
                            state = viewModel.state.collectAsState().value,
                            elapsedSec = viewModel.elapsedSec.collectAsState().value,
                            accentColor = androidx.compose.ui.graphics.Color(viewModel.settings.collectAsState().value.accentColor),
                            onStart = { viewModel.start() },
                            onPause = { viewModel.pause() },
                            onResume = { viewModel.resume() },
                            onReset = { viewModel.reset() },
                            onNext = { viewModel.nextPhase() },
                            onUpdateElapsed = { viewModel.updateElapsed(it) }
                        )
                        "settings" -> SettingsScreen(
                            settings = viewModel.settings.collectAsState().value,
                            onSettingsChange = { viewModel.saveSettings(it) }
                        )
                    }
                }
            }
        }
    }
}