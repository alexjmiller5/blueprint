var chrome = Application('Google Chrome');
var wins = chrome.windows();
var result = "JXA: No matching window found in Chrome process";

// The code we want to run INSIDE the browser page
var browserCode = `
    // Verify URL match inside the DOM
    if (window.location.href.includes("gemini.google.com")) {
        
        // TEST ALERT
        alert("JXA Standalone Test: Target Found. Clicking button now.");

        // Target the button
        var btn = document.querySelector('[data-test-id="side-nav-menu-button"]');
        
        if (btn) { 
            btn.click(); 
            "Success: Button clicked"; 
        } else {
            "Error: DOM Element [data-test-id='side-nav-menu-button'] not found";
        }
    } else {
        "Error: URL mismatch. Current URL: " + window.location.href;
    }
`;

// Loop through all Chrome-owned windows (browsers + PWAs)
for (var i = 0; i < wins.length; i++) {
    try {
        var tab = wins[i].activeTab();
        // Check URL to find the Gemini window
        if (tab.url().includes("gemini.google.com")) {
            // Found it! Execute the JS payload
            result = tab.execute({ javascript: browserCode });
            break; 
        }
    } catch (e) {
        // Ignore windows that might be restricted or empty
    }
}

result; // Output the result to the terminal