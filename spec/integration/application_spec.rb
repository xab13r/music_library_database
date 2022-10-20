require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  describe "GET /albums" do
    it "returns all the albums in the database" do
      response = get('/albums')

      expect(response.status).to eq(200)
      expect(response.body).to eq("Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring")
    end
  end

  describe "GET /albums/:id" do
    it "returns the title of the album given the id" do
      response = get('/albums/2')

      expect(response.status).to eq(200)
      expect(response.body).to eq("Surfer Rosa")
    end
  end

  describe "GET /artists" do
    it "returns all the artists in the database" do
      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to eq("Pixies, ABBA, Taylor Swift, Nina Simone, Kiasmos")
    end
  end

  describe "POST /albums" do
    it "adds a new albums to the database" do
      post_response = post(
        '/albums', 
        title: 'Voyage', 
        release_year: 2022, 
        artist_id: 2
      )
      get_response = get('/albums')

      expect(post_response.status).to eq 200
      expect(get_response.body).to include('Voyage')
    end
  end
  
  describe "POST /artists" do
    it "adds a new artist to the database" do
      post_response = post(
        '/artists',
        name: 'Wild Nothing',
        genre: 'Indie'
      )
      
      expect(post_response.status).to eq(200)
      
      get_response = get('/artists')
      
      expect(get_response.body).to include('Wild Nothing')
    end
  end
end
