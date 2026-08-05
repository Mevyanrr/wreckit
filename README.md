# wreckit

# 🛡️ WreckIT - AI Phishing URL Detection

WreckIT is an AI-powered phishing URL detection system that helps users identify suspicious links and assess their security risk before accessing a website.

This project uses Machine Learning to analyze URL patterns and classify links into three risk levels:

- 🟢 **AMAN** — URL does not show phishing indicators
- 🟡 **WASPADA** — URL has suspicious characteristics and requires caution
- 🔴 **BAHAYA** — URL has strong phishing indicators

---

## ✨ Features

- 🔍 Detect phishing URLs using Artificial Intelligence
- 🤖 Machine Learning-based URL classification
- 📊 Risk probability analysis
- ⚡ Real-time prediction through API
- 📱 Mobile application integration
- 🔐 Helps users avoid potentially dangerous links

---

## 🏗️ System Architecture

```
User
 |
 | Input URL
 ↓
Flutter Mobile App
 |
 | HTTP Request
 ↓
FastAPI Backend
 |
 ↓
Machine Learning Model
 |
 ↓
Risk Classification
 |
 ↓
AMAN / WASPADA / BAHAYA
```

---

## 🧠 Machine Learning Model

The Machine Learning model is developed to classify phishing and legitimate URLs based on URL characteristics and learned patterns from the dataset.

ML Repository:

🔗 https://github.com/nowwie/ml-phishing-url-detector

### Machine Learning Technologies

- Python
- Scikit-learn
- Pandas
- TF-IDF Vectorization
- Random Forest Classifier

---

## 🚀 Tech Stack

### Mobile Application
- Flutter
- Dart

### Backend API
- FastAPI
- Python

### Machine Learning
- Scikit-learn
- TF-IDF
- Random Forest

---

## 📂 Repository Structure

```
wreckit/
│
├── mobile/
│   └── Flutter Application
│
├── backend/
│   └── FastAPI Service
│
└── README.md
```

---

## ⚙️ Installation

Clone this repository:

```bash
git clone https://github.com/Mevyanrr/wreckit.git
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

---

## 👥 Contributors

Developed for Hackathon Project.
- Trisha Malina H. (Product Manager)
- Ahmad Muflih Azhari (Security Product Manager)
- Mevya Najwa R. (Front-End Developer)
- A. Hathori Astro (Back-End Developer)
- Novita Azka M. (AI & ML Developer)
---

## 📄 License

This project is licensed under the MIT License.
