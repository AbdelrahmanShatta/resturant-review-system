const { MongoClient } = require('mongodb');

async function seedDatabase() {
    const client = new MongoClient('mongodb://localhost:27017');
    
    try {
        await client.connect();
        const db = client.db('restaurant_reviews');
        
        // Clear existing restaurants and reviews
        await db.collection('restaurants').deleteMany({});
        await db.collection('reviews').deleteMany({});
        
        // Add sample restaurants
        const restaurants = [
            {
                name: "The Italian Place",
                description: "Authentic Italian cuisine in a cozy atmosphere",
                created_at: new Date()
            },
            {
                name: "Burger Heaven",
                description: "Best burgers in town with fresh ingredients",
                created_at: new Date()
            },
            {
                name: "Sushi Master",
                description: "Premium sushi and Japanese dishes",
                created_at: new Date()
            },
            {
                name: "Taco Corner",
                description: "Street-style Mexican food with a modern twist",
                created_at: new Date()
            },
            {
                name: "Green Garden",
                description: "Vegetarian and vegan options in a peaceful setting",
                created_at: new Date()
            }
        ];
        
        const result = await db.collection('restaurants').insertMany(restaurants);
        console.log(`Added ${result.insertedCount} restaurants`);
        
        // Log the IDs for testing
        const insertedRestaurants = await db.collection('restaurants').find().toArray();
        console.log('Restaurant IDs for testing:');
        insertedRestaurants.forEach(restaurant => {
            console.log(`${restaurant.name}: ${restaurant._id}`);
        });
        
    } catch (error) {
        console.error('Error seeding database:', error);
    } finally {
        await client.close();
    }
}

seedDatabase(); 