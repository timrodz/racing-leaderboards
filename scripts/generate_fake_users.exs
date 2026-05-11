# Script to add 10 fake users for testing purposes
# This script inserts realistic test users into the users table
# Usage: mix run scripts/generate_fake_users.exs
# Note: Gracefully handles duplicate names if run multiple times

alias RacingLeaderboards.Users

fake_users = [
  "John Doe",
  "Jane Smith", 
  "Michael Johnson",
  "Sarah Wilson",
  "David Brown",
  "Emily Davis",
  "Robert Miller",
  "Jessica Garcia",
  "William Anderson",
  "Ashley Martinez"
]

IO.puts("Creating fake users...")

{created_count, skipped_count} = 
  Enum.reduce(fake_users, {0, 0}, fn name, {created, skipped} ->
    case Users.create_user(%{name: name}) do
      {:ok, user} ->
        IO.puts("✓ Created user: #{user.name}")
        {created + 1, skipped}
      
      {:error, changeset} ->
        # Check if it's a unique constraint error
        if changeset.errors[:name] && 
           changeset.errors[:name] |> elem(1) |> elem(0) |> Keyword.get(:constraint) == :unique do
          IO.puts("- Skipped existing user: #{name}")
          {created, skipped + 1}
        else
          IO.puts("✗ Failed to create user #{name}: #{inspect(changeset.errors)}")
          {created, skipped}
        end
    end
  end)

IO.puts("\nSummary:")
IO.puts("- Created: #{created_count} users")
IO.puts("- Skipped: #{skipped_count} existing users")
IO.puts("- Total users in database: #{length(Users.list_users())}")