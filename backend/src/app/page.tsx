export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-between p-24">
      <h1 className="text-4xl font-bold">Restaurant Reviews API</h1>
      <div className="space-y-4">
        <p>Available endpoints:</p>
        <ul className="list-disc pl-5">
          <li>/api/reviews - GET, POST</li>
          <li>/api/leaderboard - GET</li>
        </ul>
      </div>
    </main>
  );
} 