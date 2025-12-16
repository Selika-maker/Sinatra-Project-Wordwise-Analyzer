# Word Counter & Text Analysis Tool
Overview:
A web application built with Ruby and Sinatra that analyzes text while integrating with multiple external APIs. This tool provides informative text statistics with a organized, effective interface.
Key Features:
  Text Analysis & Statistics:
    Word Counting: Accurate word detection including contractions (don't, can't), hyphenated words (well-being), and possessives (John's)
    Character Counting: Real-time character tracking
    Sentence & Paragraph Analysis: Identifies sentence boundaries and paragraph structure
    Reading Time Estimation: Calculates reading time at 200 WPM
    Word Frequency Analysis: Shows most common words with visual tags
  External API Integration:
    Dictionary API: Fetches definitions for the most common word in your text
    Advice Slip API: Retrieves random advice slips with each analysis
    Interactive Advice Loading: One-click button to fetch advice directly into the text box
  User-Friendly Interface:
    Live Character Counter: Updates in real-time as you type
    Multiple Input Options:
      Type or paste your own text
        Load random advice from the API
        Use built-in sample text for testing
        Clear text with a single click
    Keyboard Shortcuts: Ctrl+Enter to analyze, Ctrl+L to load advice
    Responsive Design: Works perfectly on mobile and desktop
  Technical Features:
    Modular Ruby Code: Clean separation of concerns with dedicated modules
    Error Handling: Graceful handling of API failures and edge cases
    Modern CSS: Gradient backgrounds, smooth animations, and responsive layouts
    Real-time Updates: Dynamic UI without page reloads for advice loading
  Technology Stack:
    Backend: Ruby 3.2.1 with Sinatra framework
    HTTP Client: HTTParty for API calls
    Frontend: Vanilla HTML, CSS, and JavaScript
    APIs: Advice Slip API (free, no authentication), Dictionary API
    Development: Live reloading with Sinatra::Reloader
  Sample Output Analysis:
  When you analyze text, the app displays:
    Word count with proper contraction handling
    Character count
    Sentence and paragraph counts
    Estimated reading time
    Visual word cloud of most common words
    Dictionary definition for the most frequent word
    Random advice from the Advice Slip API
  Use Cases:
    Writers & Editors: Analyze writing style and word usage
    Students: Check essay lengths and reading difficulty
    Content Creators: Optimize blog posts and articles
    Developers: Example of Ruby/Sinatra API integration
    Learning Tool: See how external APIs can enhance applications
  Why This Project Stands Out:
    Accurate Text Processing: Properly handles English language nuances like contractions and hyphenations
    Dual API Integration: Demonstrates working with two different external APIs
    Interactive Design: Real-time features and visual feedback
    Educational Value: Clean code structure perfect for learning Ruby web development
    Production Ready: Includes error handling, loading states, and responsive design
This project showcases practical Ruby web development, REST API integration, and modern frontend techniques in a single, cohesive application.
