require 'spec_helper'
require 'rack/test'
require_relative '../../app'

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  describe 'GET /albums' do
    it 'returns all the albums in the database' do
      response = get('/albums')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Albums</h1>')
      expect(response.body).to include('<a href="/albums/2">Surfer Rosa, 1988</a>')
      expect(response.body).to include('<a href="/albums/3">Waterloo, 1974</a>')
    end
  end

  describe 'GET /albums/:id' do
    it 'returns the title of the album given the id' do
      response = get('/albums/2')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Surfer Rosa</h1>')
      expect(response.body).to include('Release year: 1988')
      expect(response.body).to include('Artist: Pixies')
    end
  end

  describe 'POST /albums' do
    it 'adds a new albums to the database' do
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

  describe 'GET /artists' do
    it 'returns all the artists in the database' do
      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to eq('Pixies, ABBA, Taylor Swift, Nina Simone, Kiasmos')
    end
  end

  describe 'POST /artists' do
    it 'adds a new artist to the database' do
      post_response = post(
        '/artists',
        name: 'Wild Nothing',
        genre: 'Indie'
      )

      expect(post_response.status).to eq(200)

      get_response = get('/artists')

      expect(get_response.body).to include('Wild Nothing')
      expect(get_response.body).to eq('Pixies, ABBA, Taylor Swift, Nina Simone, Kiasmos, Wild Nothing')
    end
  end
end
