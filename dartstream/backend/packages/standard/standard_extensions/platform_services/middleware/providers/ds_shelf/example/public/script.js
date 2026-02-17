document.addEventListener('DOMContentLoaded', () => {
    const testApiBtn = document.getElementById('test-api');
    const apiResponse = document.getElementById('api-response');
    const apiStatus = document.getElementById('api-status');

    if (testApiBtn) {
        testApiBtn.addEventListener('click', async () => {
            testApiBtn.disabled = true;
            testApiBtn.textContent = 'Contacting Backend...';
            apiStatus.textContent = '⏳ Sending request to /api/hello...';
            apiResponse.classList.remove('show');
            apiResponse.textContent = '';

            try {
                const startTime = performance.now();
                const response = await fetch('/api/hello');
                const endTime = performance.now();

                if (!response.ok) throw new Error(`HTTP Error: ${response.status}`);

                const data = await response.json();

                apiResponse.textContent = JSON.stringify(data, null, 2);
                apiResponse.classList.add('show');
                
                apiStatus.innerHTML = `✅ <strong>Connected!</strong> Backend responded in ${(endTime - startTime).toFixed(2)}ms`;
                apiStatus.style.color = '#27ae60';
                
            } catch (error) {
                apiStatus.textContent = '❌ Connection Failed';
                apiStatus.style.color = '#c0392b';
                apiResponse.textContent = `Error: ${error.message}\nMake sure the server is running!`;
                apiResponse.classList.add('show');
            } finally {
                testApiBtn.disabled = false;
                testApiBtn.textContent = 'Ping Backend API';
            }
        });
    }
});
