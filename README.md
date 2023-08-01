# Stride
Stride is an iOS application that employs [Spotify’s Web API](https://developer.spotify.com/documentation/web-api) to create and play a personalized workout playlist matching user-specified BPM ranges, workout times, and tastes from past listening history. The app displays a map view with the average pace of run or walk as well as audio controls.

## Features
* Customized workout playlist based on user-selected BPM and workout time 
* In-app music player with play, pause, back, and skip buttons for convenient music playback.
* Live Map Tracking with speed, distance covered, and total workout time displayed in real-time
* Workout log, with all saved playlists and run details

## Getting Started
1. Download the Stride project files from the repository.
2. Go to the [Spotify Developer Page](https://developer.spotify.com/) and log in with your credentials. Navigate to your dashboard, and create an app, entering all information requested.
3. Open the project files in XCode and navigate to MyAuthConstants.swift. Replace "YOUR_CLIENT_ID", "YOUR_CLIENT_SECRET", and "YOUR_REDIRECT_URI" with your personal client id, client secret, and redirect URI given in your Spotify app dashboard.
4. Rename the "MyAuthConstants" class to "AuthConstants".
5. The app should now be ready to be simulated on your own machine.

## Developed By
Madhu Ramkumar - ramkumarmadhumita@gmail.com



