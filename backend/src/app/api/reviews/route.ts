import { NextResponse } from 'next/server';
import { MongoClient, ObjectId } from 'mongodb';

const mongoClient = new MongoClient(process.env.MONGODB_URI || 'mongodb://localhost:27017');

export async function POST(request: Request) {
    try {
        const body = await request.json();
        const { restaurantId, text, userId } = body;

        // Connect to MongoDB
        await mongoClient.connect();
        const db = mongoClient.db('restaurant_reviews');

        // Verify restaurant exists
        const restaurant = await db.collection('restaurants').findOne({ 
            _id: new ObjectId(restaurantId)
        });

        if (!restaurant) {
            console.error(`Restaurant not found with ID: ${restaurantId}`);
            return NextResponse.json({ error: 'Restaurant not found' }, { status: 404 });
        }

        // Send review to NLP service
        const nlpResponse = await fetch(`${process.env.NLP_SERVICE_URL}/analyze-sentiment`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ 
                restaurant_id: restaurantId,
                text, 
                user_id: userId 
            }),
        });

        if (!nlpResponse.ok) {
            throw new Error('Failed to analyze sentiment');
        }

        const sentimentResult = await nlpResponse.json();

        // Store the review in MongoDB
        const review = {
            restaurant_id: new ObjectId(restaurantId),
            text,
            user_id: userId,
            sentiment: sentimentResult.sentiment,
            score: sentimentResult.score,
            created_at: new Date()
        };

        await db.collection('reviews').insertOne(review);

        return NextResponse.json({
            ...review,
            _id: review._id.toString(),
            restaurant_id: review.restaurant_id.toString()
        });
    } catch (error) {
        console.error('Error processing review:', error);
        return NextResponse.json(
            { error: error instanceof Error ? error.message : 'Failed to process review' },
            { status: 500 }
        );
    } finally {
        await mongoClient.close();
    }
}

export async function GET(request: Request) {
    try {
        await mongoClient.connect();
        const db = mongoClient.db('restaurant_reviews');
        
        const { searchParams } = new URL(request.url);
        const restaurantId = searchParams.get('restaurantId');

        const query = restaurantId ? { restaurant_id: new ObjectId(restaurantId) } : {};
        const reviews = await db.collection('reviews')
            .find(query)
            .sort({ created_at: -1 })
            .limit(20)
            .toArray();

        // Convert ObjectIds to strings for JSON serialization
        const serializedReviews = reviews.map(review => ({
            ...review,
            _id: review._id.toString(),
            restaurant_id: review.restaurant_id.toString()
        }));

        return NextResponse.json(serializedReviews);
    } catch (error) {
        console.error('Error fetching reviews:', error);
        return NextResponse.json(
            { error: error instanceof Error ? error.message : 'Failed to fetch reviews' },
            { status: 500 }
        );
    } finally {
        await mongoClient.close();
    }
} 