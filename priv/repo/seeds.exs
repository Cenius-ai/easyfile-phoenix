# Seeds file for EasyFile
# Idempotent: safe to run multiple times.
# Creates demo users and sample upload records.

alias EasyFile.Repo
alias EasyFile.Accounts
alias EasyFile.Accounts.User
alias EasyFile.Uploads
alias EasyFile.Uploads.Upload

uploads_dir = Path.join(:code.priv_dir(:easy_file), "static/uploads")
File.mkdir_p!(uploads_dir)

# --- Seed a user if not present ---
seed_user = fn email, password ->
  case Repo.get_by(User, email: email) do
    nil ->
      {:ok, user} = Accounts.create_user(%{email: email, password: password})
      IO.puts("Created user: #{email}")
      user
    existing ->
      IO.puts("User already exists: #{email}")
      existing
  end
end

# --- Seed uploads for a user ---
seed_uploads = fn user, files ->
  Enum.each(files, fn attrs ->
    unless Repo.get_by(Upload, filename: attrs.filename, user_id: user.id) do
      uuid = Ecto.UUID.generate()
      ext = Path.extname(attrs.filename)
      stored = "#{uuid}#{ext}"
      File.write!(Path.join(uploads_dir, stored), "Sample: #{attrs.filename}\n")
      Uploads.create_upload(%{
        filename: attrs.filename,
        size: attrs.size,
        stored_path: stored,
        content_type: attrs.content_type,
        user_id: user.id
      })
      IO.puts("  Created upload: #{attrs.filename}")
    else
      IO.puts("  Upload already exists: #{attrs.filename}")
    end
  end)
end

# --- Users ---
u1 = seed_user.("cenius@cenius.ai", "cenius")
u2 = seed_user.("demo@example.com", "password")

# --- Uploads ---
IO.puts("\n--- Seeding uploads for cenius@cenius.ai ---")
seed_uploads.(u1, [
  %{filename: "quarterly-report-q4.pdf", size: 2_456_000, content_type: "application/pdf"},
  %{filename: "team-photo-retreat.png", size: 4_200_000, content_type: "image/png"},
  %{filename: "project-roadmap.csv", size: 15_800, content_type: "text/csv"},
  %{filename: "logo-variants.zip", size: 8_900_000, content_type: "application/zip"},
  %{filename: "meeting-notes-january.txt", size: 3_200, content_type: "text/plain"},
  %{filename: "budget-forecast-2025.xlsx", size: 1_200_000, content_type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"},
  %{filename: "architecture-diagram.png", size: 5_600_000, content_type: "image/png"},
  %{filename: "client-contract-signed.pdf", size: 3_100_000, content_type: "application/pdf"},
  %{filename: "api-specification.json", size: 42_500, content_type: "application/json"},
  %{filename: "presentation-slides.pptx", size: 6_800_000, content_type: "application/vnd.openxmlformats-officedocument.presentationml.presentation"},
  %{filename: "headshot-profile.jpg", size: 2_800_000, content_type: "image/jpeg"},
  %{filename: "code-style-guide.doc", size: 520_000, content_type: "application/msword"}
])

IO.puts("\n--- Seeding uploads for demo@example.com ---")
seed_uploads.(u2, [
  %{filename: "onboarding-checklist.pdf", size: 1_800_000, content_type: "application/pdf"},
  %{filename: "expense-report-march.csv", size: 8_500, content_type: "text/csv"},
  %{filename: "office-layout-v2.png", size: 3_400_000, content_type: "image/png"},
  %{filename: "policy-handbook-2025.pdf", size: 4_500_000, content_type: "application/pdf"},
  %{filename: "team-directory.json", size: 12_300, content_type: "application/json"},
  %{filename: "summer-party-photos.zip", size: 15_000_000, content_type: "application/zip"}
])

IO.puts("\nSeeds complete. Demo accounts: cenius@cenius.ai / cenius  |  demo@example.com / password")
