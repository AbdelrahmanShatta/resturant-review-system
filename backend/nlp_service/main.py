from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from transformers import pipeline
import redis
from pymongo import MongoClient
import os
from dotenv import load_dotenv

load_dotenv()

app = FastAPI()

# Initialize sentiment analysis pipeline
sentiment_analyzer = pipeline("sentiment-analysis")

# Initialize Redis connection
redis_client = redis.Redis(
    host=os.getenv('REDIS_HOST', 'localhost'),
    port=int(os.getenv('REDIS_PORT', 6379)),
    decode_responses=True
)

# Initialize MongoDB connection
mongo_client = MongoClient(os.getenv('MONGODB_URI', 'mongodb://localhost:27017'))
db = mongo_client['restaurant_reviews']

class Review(BaseModel):
    restaurant_id: str
    text: str
    user_id: str

@app.post("/analyze-sentiment")
async def analyze_sentiment(review: Review):
    try:
        # Analyze sentiment
        sentiment_result = sentiment_analyzer(review.text)[0]
        score = 1 if sentiment_result['label'] == 'POSITIVE' else -1
        
        # Update restaurant score in Redis
        redis_client.zincrby('restaurant_leaderboard', score, review.restaurant_id)
        
        # Store review in MongoDB
        db.reviews.insert_one({
            'restaurant_id': review.restaurant_id,
            'text': review.text,
            'user_id': review.user_id,
            'sentiment': sentiment_result['label'],
            'score': score
        })
        
        return {
            'sentiment': sentiment_result['label'],
            'score': score,
            'confidence': sentiment_result['score']
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/leaderboard")
async def get_leaderboard(limit: int = 10):
    try:
        # Get top restaurants from Redis
        leaderboard = redis_client.zrevrange(
            'restaurant_leaderboard',
            0,
            limit - 1,
            withscores=True
        )
        return [{'restaurant_id': rest_id, 'score': score} for rest_id, score in leaderboard]
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000) 