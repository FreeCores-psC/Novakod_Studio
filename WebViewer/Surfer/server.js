import express from "express";
import fs from "fs";
import path from "path";

const app = express();
const PORT = 3000;

const VCD_DIR = path.resolve("./vcd");          // where your .vcd files are
const SURFER_DIR = path.resolve("./surfer_pages"); // the pages_build folder

app.use((req, res, next) => { res.setHeader("Cache-Control", "no-store"); next(); });

// Serve your shell page + any assets
app.use(express.static("public"));

// Serve Surfer
app.use("/surfer", express.static(SURFER_DIR));

// API: list VCD files
app.get("/api/vcd", (req, res) => {
  fs.readdir(VCD_DIR, (err, files) => {
    if (err) return res.status(500).json({ error: "Cannot read vcd directory" });
    res.json(files.filter(f => f.toLowerCase().endsWith(".vcd")).sort());
  });
});

// API: list SUCL files (optional)
app.get("/api/sucl", (req, res) => {
  fs.readdir(VCD_DIR, (err, files) => {
    if (err) return res.status(500).json({ error: "Cannot read vcd directory" });
    res.json(files.filter(f => f.toLowerCase().endsWith(".sucl")).sort());
  });
});

// Serve VCD file
app.get("/vcd/:name", (req, res) => {
  const name = String(req.params.name || "");
  if (!/^[a-zA-Z0-9._-]+\.vcd$/i.test(name)) return res.status(400).send("Bad filename");

  const full = path.join(VCD_DIR, name);
  fs.stat(full, (err, st) => {
    if (err || !st.isFile()) return res.status(404).send("Not found");
    res.type("text/plain");
    fs.createReadStream(full).pipe(res);
  });
});  

app.get("/sucl/:name", (req, res) => {
  const name = String(req.params.name || "");
  if (!/^[a-zA-Z0-9._-]+\.sucl$/i.test(name)) {
    return res.status(400).send("Bad filename");
  }

  const full = path.join(VCD_DIR, name);
  fs.stat(full, (err, st) => {
    if (err || !st.isFile()) return res.status(404).send("Not found");
    res.type("text/plain");
    fs.createReadStream(full).pipe(res);
  });
});

app.listen(PORT, () => console.log(`http://localhost:${PORT}/`));
