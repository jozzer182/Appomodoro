package com.zarabandajose.appomodoro

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.zarabandajose.appomodoro.ui.PomodoroViewModel
import com.zarabandajose.appomodoro.ui.screens.HomeScreen
import com.zarabandajose.appomodoro.ui.screens.SettingsScreen
import com.zarabandajose.appomodoro.ui.theme.AppomodoroTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            AppomodoroTheme {
                AppomodoroApp()
            }
        }
    }
}

@Composable
fun AppomodoroApp() {
    val navController = rememberNavController()
    val viewModel: PomodoroViewModel = viewModel()
    
    NavHost(
        navController = navController,
        startDestination = "home",
        modifier = Modifier.fillMaxSize()
    ) {
        composable("home") {
            HomeScreen(
                viewModel = viewModel,
                onNavigateToSettings = {
                    navController.navigate("settings")
                }
            )
        }
        
        composable("settings") {
            SettingsScreen(
                viewModel = viewModel,
                onNavigateBack = {
                    navController.popBackStack()
                }
            )
        }
    }
}