# Finance_Manager_ledgerflow
Finance Manager helps users record daily financial transactions, categorize expenses and income, and visualize their financial activity through clean charts, tables, and summaries.

Finance Manager — Flutter Mobile Application
A modern, offline‑first personal finance management app built with Flutter and Hive. Finance Manager helps users record daily financial transactions, categorize expenses and income, and visualize their financial activity through clean charts, tables, and summaries.

This repository contains the complete mobile application source code, including UI components, local storage logic, chart rendering, and navigation structure.

🚀 Overview
Finance Manager is designed for users who want a simple, fast, and reliable way to track their finances directly on their device — without cloud accounts, logins, or external dependencies.

The app stores all data locally using Hive and provides a smooth, responsive UI for browsing and analyzing financial activity.

🧩 Key Features
Record transactions (title, price, date, currency, category, type)

Categorize receipts and payments

Local offline storage using Hive

Daily, monthly, and yearly summaries

Interactive charts using fl_chart

Scrollable tables for detailed views

Clean navigation with custom HoverIconButton

Crash‑proof screens with null‑safe parsing

Modern UI with responsive layouts

📦 Tech Stack
Frontend
Flutter

Dart

Hive (local NoSQL storage)

fl_chart (visualization)

Custom UI widgets

Architecture
Offline‑first

Local database

Stateless + Stateful widgets

Clean navigation structure

🛠️ What Was Built (Based on Development Queries)
This project includes solutions to several real-world issues encountered during development:

✔ Hive Model Integration
You created a Money model with fields:

id

title

price

date

currency

isReceived

category

We resolved:

Date formatting issues

Price parsing issues

Category mapping

Hive box access patterns

✔ ForecastScreen Crash Fixes
You encountered:

Null is not a subtype of List<dynamic>

Screen freezing after navigation

Incorrect Scaffold structure

Missing null checks

Incorrect date conversion

We fixed:

Safe parsing of per_category

Proper Scaffold return flow

Correct date handling (String date)

Navigation freeze caused by backend calls

✔ UI Improvements
You implemented:

HoverIconButton navigation

Loading indicators

Bar charts

Data tables

Summary text sections

We improved:

Chart safety checks

Table rendering

Navigation stability

Error handling

📸 Video 



https://github.com/user-attachments/assets/fa5fa16d-10c7-44c6-b23b-1653353f8ff1



🧪 How to Run
Code
flutter pub get
flutter run
