# Cycad

![Cycad Banner](assets/cycad_banner.png)

Cycad is a playing card deck editor app, specifically designed for story-driven physical games. It is the successor to [Forge](https://github.com/zzlazo/forge).

While the original Forge used local storage, Cycad has been migrated to a server-side architecture, Supabase, to enable reliable data management.

Cycad is built for:

- Language Learning: Build real-world fluency by combining "situations" and "challenges."
  - Example: Pair "Airport" with "Missing Reservation" to practice immediate problem-solving in your target language.
- Programming Patterns: Sharpen your software design intuition through rapid-fire coding drills.
  - Example: Draw a "Code Smell" like "Deeply Nested Loops" and decide which "Refactoring Technique" (e.g., "Early Return") to apply.
- Physical games: Help Game Masters create unpredictable story twists and dynamic encounters on the fly.
  - Example: Generate random "NPC Traits" or "Environmental Events" and use the Image Export feature to share them with players instantly.
- Fitness (Personal Bootcamp): Add a layer of gamification to your workouts by randomizing exercises and intensity.
  - Example: Pair "Squats" with "Until Failure" and track your progress over time using the built-in Activity Logging.

## Features

Currently, the following functions are available:

- Card Customization: Edit card text and colors to match your game's world.
- Image Export: Export your custom cards as images for use in digital tools or printing.
- Activity Logging (New!): Record logs of your gameplay sessions and story progress.

## Prerequisites

You can use this app by setting up your own Supabase environment. Please configure your API keys in the environment variables.

## Project Structure

This repository is a monorepo organized as follows:

- `app/`: The Flutter-based client application for Android.
- `supabase/`: Contains the backend configuration, including SQL database schemas.

## License

This app is released under the MIT license. For more information, see LICENSE.md
