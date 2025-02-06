import { NextResponse } from 'next/server';
import { MongoClient, ObjectId } from 'mongodb';

const mongoClient = new MongoClient(process.env.MONGODB_URI || 'mongodb://localhost:27017');

export async function GET(request: Request) {
    try {
        const { searchParams } = new URL(request.url);
        const limit = parseInt(searchParams.get('limit') || '10');

        // Get restaurants from MongoDB
        await mongoClient.connect();
        const db = mongoClient.db('restaurant_reviews');
        const restaurants = await db.collection('restaurants')
            .find()
            .limit(limit)
            .toArray();

        // Get scores from NLP service
        const response = await fetch(`${process.env.NLP_SERVICE_URL}/leaderboard?limit=${limit}`);
        
        if (!response.ok) {
            throw new Error(`Failed to fetch leaderboard from NLP service: ${response.statusText}`);
        }

        const scores = await response.json();

        // Combine restaurant data with scores
        const leaderboard = restaurants.map(restaurant => {
            const restaurantId = restaurant._id.toString();
            const scoreData = scores.find((s: any) => s.restaurant_id === restaurantId);
            return {
                ...restaurant,
                _id: restaurantId, // Convert ObjectId to string
                score: scoreData?.score || 0
            };
        });

        return NextResponse.json(leaderboard);
    } catch (error) {
        console.error('Error fetching leaderboard:', error);
        return NextResponse.json(
            { error: error instanceof Error ? error.message : 'Failed to fetch leaderboard' },
            { status: 500 }
        );
    } finally {
        await mongoClient.close();
    }
} 