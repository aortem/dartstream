// Verify JavaScript loaded
document.addEventListener("DOMContentLoaded", () => {
  console.log("✅ JavaScript loaded successfully!");

  // Update JS check status
  const jsCheck = document.getElementById("js-check");
  if (jsCheck) {
    jsCheck.textContent = "✓ JavaScript loaded and executed";
    jsCheck.style.color = "#28a745";
  }

  const jsStatus = document.getElementById("js-status");
  if (jsStatus) {
    jsStatus.textContent = "✓ Executed";
    jsStatus.className = "status-ok";
  }

  // Set timestamp
  const timestamp = document.getElementById("timestamp");
  if (timestamp) {
    timestamp.textContent = new Date().toLocaleString();
  }

    // API test button
    const testApiBtn = document.getElementById('test-api');
    const apiResponse = document.getElementById('api-response');
    const apiStatus = document.getElementById('api-status');
    
    if (testApiBtn && apiResponse) {
        testApiBtn.addEventListener('click', async () => {
            testApiBtn.disabled = true;
            testApiBtn.textContent = 'Contacting Backend...';
            if (apiStatus) apiStatus.textContent = '⏳ Sending request to /api/hello...';
            apiResponse.textContent = '';
            apiResponse.classList.remove('show');
            
            try {
                const startTime = performance.now();
                const response = await fetch('/api/hello');
                const endTime = performance.now();
                
                if (!response.ok) throw new Error(`HTTP Error: ${response.status}`);
                
                const data = await response.json();
                
                apiResponse.textContent = JSON.stringify(data, null, 2);
                apiResponse.classList.add('show');
                
                if (apiStatus) {
                    apiStatus.innerHTML = `✅ <strong>Connected!</strong> Backend responded in ${(endTime - startTime).toFixed(2)}ms`;
                    apiStatus.style.color = '#28a745';
                }
                console.log('Backend Response:', data);
            } catch (error) {
                apiResponse.textContent = `Connection Failed: ${error.message}\nMake sure the DartStream backend is running!`;
                apiResponse.classList.add('show');
                apiResponse.style.color = '#ff0000';
                 if (apiStatus) {
                    apiStatus.textContent = '❌ Connection Failed';
                    apiStatus.style.color = '#ff0000';
                }
            } finally {
                testApiBtn.disabled = false;
                testApiBtn.textContent = 'Ping Backend API';
            }
        });
    }

  // Log all static files that loaded
  console.log("📁 Static Files Verification:");
  console.log("  ✓ HTML: index.html");
  console.log("  ✓ CSS: styles.css");
  console.log("  ✓ JS: script.js");
  console.log("  ✓ SVG: logo.svg");
});
