const logDiv = document.getElementById("log");

function log(msg) {
  const entry = document.createElement("div");
  entry.textContent = `[${new Date().toLocaleTimeString()}] ${msg}`;
  logDiv.appendChild(entry);
  logDiv.scrollTop = logDiv.scrollHeight;
}

async function runHeavy() {
  log("⏳ Starting Heavy Task (Fib 40)...");
  const start = Date.now();
  try {
    const res = await fetch("/fib/40");
    const text = await res.text();
    const duration = Date.now() - start;
    log(`✅ Heavy Task Complete (${duration}ms): ${text}`);
  } catch (e) {
    log(`❌ Heavy Task Failed: ${e}`);
  }
}

async function runLight() {
  log("📤 Starting Light Task (Echo)...");
  const start = Date.now();
  try {
    const res = await fetch("/echo/WebClient");
    const text = await res.text();
    const duration = Date.now() - start;
    log(`✅ Light Task Complete (${duration}ms): ${text}`);
  } catch (e) {
    log(`❌ Light Task Failed: ${e}`);
  }
}
