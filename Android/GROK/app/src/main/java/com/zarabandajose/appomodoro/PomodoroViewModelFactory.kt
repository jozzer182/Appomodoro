package com.zarabandajose.appomodoro

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.zarabandajose.appomodoro.data.SettingsStore

class PomodoroViewModelFactory(private val settingsStore: SettingsStore) : ViewModelProvider.Factory {
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(PomodoroViewModel::class.java)) {
            @Suppress("UNCHECKED_CAST")
            return PomodoroViewModel(settingsStore.context, settingsStore) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }
}