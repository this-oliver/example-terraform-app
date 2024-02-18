import Express from "express";
import Cors from "cors";

const PORT = process.env.PORT || 3000;

const app = Express();
app.use(Cors());

app.get("/info", (req, res) => {
	res.send("This is an simple express.js server for Terraform deployment.");
});

app.get("/", (req, res) => {
	const seed = Math.random();
	const placeholderImage = `https://picsum.photos/seed/${seed}/200/300`;
	const html = `
    <html>
      <head>
        <title>Simple Express Server</title>
      </head>
      <body>
        <h1>Served to you by Express 🚀 + Docker 🐳 + Terraform 📜</h1>
        <img src="${placeholderImage}" alt="Placeholder image" width="200" height="300" />
      </body>
    </html>
  `;

	res.send(html);
});

app.listen(PORT, () => {
	console.log(`Server is running at http://localhost:${PORT}`);
});
