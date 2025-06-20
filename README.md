# 📱 Flutter Invoice Generator App

A simple yet dynamic Flutter mobile application that allows users to create and preview invoices in real time.

## 🧾 Objective

This project was developed as part of a front-end technical test. The goal is to implement an interactive invoice creation module using **Flutter**, where users can:

- Add or remove articles
- Input client details and invoice date
- View total amounts (HT, TVA, TTC) updated in real time
- Preview the structured invoice

---

## 🛠 Features

### 1. Invoice Form (Dynamic)

- **Client Name & Email** input fields
- **Invoice Date** selection via Date Picker
- **Dynamic list of articles** with:
  - Description
  - Quantity (validated)
  - Unit Price HT (validated)
  - Automatically calculated total HT per article
- Button to **Add Article**
- Realtime calculations for:
  - Total HT
  - TVA (20%)
  - Total TTC

### 2. Article Management

Each article is displayed in a card. Users can:
- Enter details
- Delete articles using a trash icon
- See totals update live on every change

### 3. Invoice Preview

- Accessible by tapping **Preview Invoice**
- Displays:
  - Client information
  - Date
  - Table of articles (description, quantity, unit price, total HT)
  - Totals (HT, TVA, TTC)
- Structured layout simulating a real invoice

---

## 🧩 Architecture

The app is modular and split into several components:

| File | Role |
|------|------|
| `models/article.dart` | Defines the `Article` data model |
| `screens/invoice_screen.dart` | Main screen for creating invoice |
| `screens/invoice_preview_screen.dart` | Invoice preview screen |
| `widgets/article_item.dart` | UI component for each article item |
| `widgets/invoice_form.dart` | UI component for client form info |

---

## ✨ Bonus Features Implemented

- ✅ Modular components (`ArticleItem`, `InvoiceForm`, `InvoicePreviewScreen`)
- ✅ Clean and responsive UI using `ListView`, `Card`, and `Divider`
- ✅ Realtime updates on every edit
- ✅ Clear structure with separation of logic and UI

---

## ⚙️ Getting Started

### Requirements

- Flutter 3.x+
- Dart SDK
- Emulator or physical Android/iOS device

### Run the app

```bash
git clone https://github.com/AchRef864/invoice_app.git
cd invoice_app
flutter pub get
flutter run
