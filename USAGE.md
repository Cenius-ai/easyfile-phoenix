# Usage

## Starting the Application

Run the development server:

```sh
mix phx.server
```

## Web Interface

1. Open `http://localhost:4000` in your browser. You will see the sign‑in page (rendered by `session_html/new.html.heex`).
2. Sign in with the demo user credentials. The exact email and password are defined in `priv/repo/seeds.exs`. After successful authentication you are redirected to the file list.
3. The file list page (`file_html/index.html.heex`) displays all your uploaded files, showing their name and size.
4. To upload a new file, navigate to the upload page (rendered by `file_html/new.html.heex`). Select a file and submit the form.
5. After uploading, you are returned to the file list where the new file appears.