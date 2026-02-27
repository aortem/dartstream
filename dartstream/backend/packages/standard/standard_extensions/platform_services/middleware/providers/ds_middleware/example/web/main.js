const API_BASE = "http://localhost:8086";

async function fetchTime() {
  const resultBox = document.getElementById("time-result");
  resultBox.innerText = "Fetching...";
  resultBox.style.color = "var(--primary)";

  try {
    const response = await fetch(`${API_BASE}/time`);
    if (!response.ok) throw new Error(`Status: ${response.status}`);

    const data = await response.text();
    resultBox.innerText = data;
  } catch (error) {
    resultBox.innerText = `Error: ${error.message}`;
    resultBox.style.color = "#ff4444";
  }
}

async function postUser() {
  const resultBox = document.getElementById("user-result");
  const name = document.getElementById("user-name").value;
  const age = parseInt(document.getElementById("user-age").value);

  resultBox.innerText = "Updating...";
  resultBox.style.color = "var(--secondary)";

  try {
    const response = await fetch(`${API_BASE}/user`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ name, age }),
    });

    if (!response.ok) {
      const errData = await response.json();
      throw new Error(errData.error || `Status: ${response.status}`);
    }

    const data = await response.json();
    resultBox.innerText = JSON.stringify(data, null, 2);
    resultBox.style.color = "var(--secondary)";
  } catch (error) {
    resultBox.innerText = `Error: ${error.message}`;
    resultBox.style.color = "#ff4444";
  }
}
