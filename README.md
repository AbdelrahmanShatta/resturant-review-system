# Restaurant Review System with Sentiment Analysis

A full-stack application that allows users to review restaurants and automatically analyzes the sentiment of reviews to maintain a real-time leaderboard.

## Tech Stack

- **Frontend**: Flutter Web
- **Backend**: Next.js (TypeScript)
- **NLP Service**: Python (FastAPI)
- **Databases**: 
  - MongoDB (restaurant and review data)
  - Redis (real-time leaderboard)

## Features

- Restaurant listing with descriptions
- Real-time review submission
- Sentiment analysis of reviews
- Automatic leaderboard updates based on review sentiment
- Responsive web interface

## Project Structure

```
.
├── backend/               # Next.js backend
│   ├── src/              # Source code
│   ├── nlp_service/      # Python NLP service
│   └── scripts/          # Database scripts
└── frontend/             # Flutter frontend
    └── lib/              # Flutter source code
```

## Setup Instructions

1. **Prerequisites**
   - Node.js (v14 or higher)
   - Python 3.8 or higher
   - Flutter SDK
   - MongoDB
   - Redis

2. **Backend Setup**
   ```bash
   # Install Next.js dependencies
   cd backend
   npm install

   # Install Python dependencies
   cd nlp_service
   pip install -r requirements.txt
   ```

3. **Frontend Setup**
   ```bash
   cd frontend
   flutter pub get
   ```

4. **Database Setup**
   ```bash
   # Seed the database with sample restaurants
   cd backend
   node scripts/seed_data.js
   ```

5. **Running the Application**
   ```bash
   # Start MongoDB and Redis
   # Start the NLP service
   cd backend/nlp_service
   python -m uvicorn main:app --reload

   # Start the Next.js backend
   cd backend
   npm run dev

   # Start the Flutter frontend
   cd frontend
   flutter run -d chrome
   ```

## Environment Variables

Create a `.env` file in the `backend` directory:

```env
MONGODB_URI=mongodb://localhost:27017
REDIS_HOST=localhost
REDIS_PORT=6379
NLP_SERVICE_URL=http://localhost:8000
```

## API Endpoints

- `GET /api/leaderboard` - Get restaurant leaderboard
- `GET /api/reviews` - Get restaurant reviews
- `POST /api/reviews` - Submit a new review

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request # resturant-review-system
