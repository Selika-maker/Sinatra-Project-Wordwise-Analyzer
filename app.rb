# app.rb
require "sinatra"
require "sinatra/reloader"
require "httparty"
require "json"

# Helper methods for word counting
module WordCounter
  def self.count_words(text)
    return 0 if text.nil? || text.empty?
    text.scan(/\w+/).size
  end

  def self.count_characters(text)
    text.to_s.length
  end

  def self.count_sentences(text)
    text.to_s.scan(/[.!?]+/).size
  end

  def self.count_paragraphs(text)
    text.to_s.split(/\n\n+/).size
  end

  def self.most_common_words(text, limit = 5)
    return [] if text.nil? || text.empty?
    
    words = text.downcase.scan(/\b[a-z]{3,}\b/)
    stop_words = %w[the and to of a in for is on that by this with i you it not or be are from at as your all have new more an was we will can just]
    
    words.reject! { |word| stop_words.include?(word) }
    
    word_counts = words.each_with_object(Hash.new(0)) do |word, counts|
      counts[word] += 1
    end
    
    word_counts.sort_by { |_, count| -count }.first(limit)
  end
end

# Dictionary API for word definitions
module DictionaryAPI
  def self.lookup(word)
    begin
      response = HTTParty.get(
        "https://api.dictionaryapi.dev/api/v2/entries/en/#{word}",
        headers: {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json'
        },
        timeout: 3
      )
      
      if response.success?
        data = JSON.parse(response.body)
        # Extract the first definition
        if data[0] && data[0]['meanings'] && data[0]['meanings'][0] && data[0]['meanings'][0]['definitions'] && data[0]['meanings'][0]['definitions'][0]
          definition = data[0]['meanings'][0]['definitions'][0]['definition']
          {
            word: word,
            definition: definition,
            success: true
          }
        else
          {
            word: word,
            error: "No definition found",
            success: false
          }
        end
      else
        {
          word: word,
          error: "Word not found in dictionary",
          success: false
        }
      end
    rescue => e
      {
        word: word,
        error: "API Error: #{e.message}",
        success: false
      }
    end
  end
end

# Advice Slip API for random advice
module AdviceAPI
  def self.fetch_random_advice
    begin
      response = HTTParty.get(
        'https://api.adviceslip.com/advice',
        headers: {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json'
        },
        timeout: 3
      )
      
      if response.success?
        data = JSON.parse(response.body)
        # The API returns format: {"slip": {"id": 123, "advice": "Some advice here"}}
        if data['slip'] && data['slip']['advice']
          {
            advice: data['slip']['advice'],
            id: data['slip']['id'],
            success: true
          }
        else
          {
            error: "Unexpected API response format",
            success: false
          }
        end
      else
        {
          error: "Failed to fetch advice",
          success: false
        }
      end
    rescue HTTParty::Error => e
      {
        error: "HTTP Error: #{e.message}",
        success: false
      }
    rescue StandardError => e
      {
        error: "Error: #{e.message}",
        success: false
      }
    end
  end
  
  # New method to get just the advice text for the text box
  def self.fetch_advice_for_textbox
    advice_data = fetch_random_advice
    advice_data[:success] ? advice_data[:advice] : "Failed to fetch advice. Please try again."
  end
end

# Sinatra Routes
get "/" do
  erb :index
end

# New route to get advice for textbox (returns JSON)
get "/get_advice" do
  content_type :json
  { advice: AdviceAPI.fetch_advice_for_textbox }.to_json
end

post "/analyze" do
  @text = params[:text] || ""
  
  # Calculate metrics
  @word_count = WordCounter.count_words(@text)
  @char_count = WordCounter.count_characters(@text)
  @sentence_count = WordCounter.count_sentences(@text)
  @paragraph_count = WordCounter.count_paragraphs(@text)
  @common_words = WordCounter.most_common_words(@text)
  @reading_time = [(@word_count / 200.0).ceil, 1].max
  
  # Fetch definition for the most common word (if any)
  @word_definition = nil
  if @common_words.any?
    most_common_word = @common_words[0][0]  # [0] is the word, [1] is the count
    @word_definition = DictionaryAPI.lookup(most_common_word)
  end
  
  # Fetch advice from Advice Slip API
  @advice = AdviceAPI.fetch_random_advice
  
  erb :index
end
