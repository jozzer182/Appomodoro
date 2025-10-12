package com.zarabandajose.appomodoro.ui

import android.Manifest
import android.app.AlarmManager
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.result.contract.ActivityResultContracts
import androidx.activity.viewModels
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Home
import androidx.compose.material.icons.outlined.Settings
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarDuration
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.zarabandajose.appomodoro.R
import com.zarabandajose.appomodoro.model.PomodoroSettings
import com.zarabandajose.appomodoro.model.PomodoroTimerState
import com.zarabandajose.appomodoro.ui.screens.HomeScreen
import com.zarabandajose.appomodoro.ui.screens.SettingsScreen
import com.zarabandajose.appomodoro.ui.theme.AppTheme

class MainActivity : ComponentActivity() {

    private val viewModel: PomodoroViewModel by viewModels { PomodoroViewModel.factory(applicationContext) }

    private val notificationPermissionLauncher = registerForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { granted ->
        if (!granted) {
            viewModel.updateNotifications(false)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            val timerState by viewModel.timerState.collectAsStateWithLifecycle()
            val settings by viewModel.settings.collectAsStateWithLifecycle()
            val accentColor = remember(settings.accentColor) { Color(settings.accentColor) }
            val snackbarHostState = remember { SnackbarHostState() }
            var canExactAlarms by remember { mutableStateOf(canScheduleExactAlarms()) }
            DisposableEffect(Unit) {
                val observer = LifecycleEventObserver { _, event ->
                    if (event == Lifecycle.Event.ON_RESUME) {
                        canExactAlarms = canScheduleExactAlarms()
                    }
                }
                lifecycle.addObserver(observer)
                onDispose { lifecycle.removeObserver(observer) }
            }

            LaunchedEffect(Unit) {
                viewModel.events.collect { event ->
                    when (event) {
                        is PomodoroViewModel.PomodoroEvent.PhaseCompleted -> {
                            snackbarHostState.showSnackbar(
                                message = this@MainActivity.getString(
                                    R.string.snackbar_phase_transition,
                                    this@MainActivity.getString(event.completedPhase.labelRes),
                                    this@MainActivity.getString(event.upcomingPhase.labelRes)
                                ),
                                duration = SnackbarDuration.Short
                            )
                        }
                    }
                }
            }

            AppTheme(accentColor = accentColor) {
                MainContent(
                    timerState = timerState,
                    settings = settings,
                    accentColor = accentColor,
                    snackbarHostState = snackbarHostState,
                    canScheduleExactAlarms = canExactAlarms,
                    onRequestNotificationPermission = { requestNotificationPermissionIfNeeded() },
                    onOpenExactAlarmSettings = { openExactAlarmSettings() },
                    viewModel = viewModel
                )
            }
        }
    }

    private fun requestNotificationPermissionIfNeeded() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            notificationPermissionLauncher.launch(Manifest.permission.POST_NOTIFICATIONS)
        }
    }

    private fun canScheduleExactAlarms(): Boolean {
        val alarmManager = getSystemService(AlarmManager::class.java)
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            alarmManager?.canScheduleExactAlarms() == true
        } else {
            true
        }
    }

    private fun openExactAlarmSettings() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val intent = Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM).apply {
                data = Uri.parse("package:$packageName")
            }
            startActivity(intent)
        }
    }
}

private enum class AppDestination { Home, Settings }

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun MainContent(
    timerState: PomodoroTimerState,
    settings: PomodoroSettings,
    accentColor: Color,
    snackbarHostState: SnackbarHostState,
    canScheduleExactAlarms: Boolean,
    onRequestNotificationPermission: () -> Unit,
    onOpenExactAlarmSettings: () -> Unit,
    viewModel: PomodoroViewModel
) {
    var destination by rememberSaveable { mutableStateOf(AppDestination.Home) }

    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                title = { Text(text = stringResource(id = R.string.app_name)) }
            )
        },
        snackbarHost = { SnackbarHost(snackbarHostState) },
        bottomBar = {
            NavigationBar {
                NavigationBarItem(
                    selected = destination == AppDestination.Home,
                    onClick = { destination = AppDestination.Home },
                    icon = { Icon(Icons.Outlined.Home, contentDescription = null) },
                    label = { Text(text = stringResource(id = R.string.nav_home)) }
                )
                NavigationBarItem(
                    selected = destination == AppDestination.Settings,
                    onClick = { destination = AppDestination.Settings },
                    icon = { Icon(Icons.Outlined.Settings, contentDescription = null) },
                    label = { Text(text = stringResource(id = R.string.nav_settings)) }
                )
            }
        }
    ) { paddingValues ->
        when (destination) {
            AppDestination.Home -> HomeScreen(
                timerState = timerState,
                settings = settings,
                accentColor = accentColor,
                onStart = { viewModel.startOrResume() },
                onPause = { viewModel.pause() },
                onResume = { viewModel.startOrResume() },
                onReset = { viewModel.reset() },
                onSkip = { viewModel.skipPhase() },
                onSelectPhase = { phase -> viewModel.selectPhase(phase) },
                modifier = Modifier.padding(paddingValues)
            )

            AppDestination.Settings -> SettingsScreen(
                settings = settings,
                onDurationsChange = { focus, short, long, custom -> viewModel.updateDurations(focus, short, long, custom) },
                onAccentSelected = { viewModel.updateAccent(it) },
                onAutoAdvanceChanged = { viewModel.updateAutoAdvance(it) },
                onNotificationsChanged = { viewModel.updateNotifications(it) },
                onRequestNotificationPermission = onRequestNotificationPermission,
                canScheduleExactAlarm = canScheduleExactAlarms,
                onOpenExactAlarmSettings = onOpenExactAlarmSettings,
                modifier = Modifier.padding(paddingValues)
            )
        }
    }
}
